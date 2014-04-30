module Api

  class ReportsController < ApplicationController
    resource_description do
      short 'Reports'
      formats ['xml']
      description <<-RCDESC
        This resource is responsible for the generation of QRDA Category III reports from clincial
        quality measure calculations.
      RCDESC
    end

    before_filter :authenticate_user!
    skip_authorization_check

    api :GET, '/reports/qrda_cat3.xml', "Retrieve a QRDA Category III document"
    param :measure_ids, Array, :desc => 'The HQMF ID of the measures to include in the document', :required => false
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
                                   :required => false
    param :provider_id, String, :desc => 'The Provider ID for CATIII generation'
    description <<-CDESC
      This action will generate a QRDA Category III document. If measure_ids and effective_date are not provided,
      the values from the user's dashboard will be used.
    CDESC
    def cat3
      measure_ids = params[:measure_ids] ||current_user.preferences["selected_measure_ids"]
      filter = measure_ids=="all" ? {}  : {:hqmf_id.in =>measure_ids.map { |mId| mId.upcase }}
      exporter =  HealthDataStandards::Export::Cat3.new
      effective_date = params["effective_date"] || current_user.effective_date || Time.gm(2012, 12, 31)
      end_date = Time.at(effective_date.to_i)
      provider = provider_filter = nil
      if params[:provider_id].present?
        provider = Provider.find(params[:provider_id])
        provider_filter = {}
        provider_filter['filters.providers'] = params[:provider_id] if params[:provider_id].present?
      end
      render xml: exporter.export(HealthDataStandards::CQM::Measure.top_level.where(filter),
                                   generate_header(provider),
                                   effective_date.to_i,
                                   end_date.years_ago(1),
                                   end_date, provider_filter), content_type: "attachment/xml"
    end

    api :POST, '/reports/qrda_cat3_inplace', "Retrieve a QRDA Category III document calculated from passed in QRDA Category I patient files"
    param :measure_ids, Array, :desc => 'The HQMF ID of the measures to include in the document', :required => false
    param :effective_date, String, :desc => 'Time in seconds since the epoch for the end date of the reporting period', :required => false
    param :start_date, String, :desc => 'Time in seconds since the epoch for the start date of the reporting period', :required => false
    param :cat1_zip, nil, :desc => 'Zip archive of patient QRDA Category 1 files for measures requested', :required => true
    description <<-CDESC
      This action will generate a QRDA Category III document calculated over passed in QRDA Category I patient files. If measure_ids and effective_date are not provided,
      the values from the user's dashboard will be used.
    CDESC
    def cat3_inplace

      file = params[:cat1_zip]

      # Save zip to temp location
      FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
      file_location = File.join(Dir.pwd, "tmp/import")
      file_name = "patient_upload" + Time.now.to_i.to_s + rand(1000).to_s
      temp_file = File.new(file_location + "/" + file_name, "w")
      File.open(temp_file.path, "wb") { |f| f.write(file.read) }

      # Generate unique id used for the calculation
      test_id = Moped::BSON::ObjectId.new

      # Import records
      Zip::ZipFile.open(temp_file.path) do |zipfile|
        zipfile.entries.each do |entry|
          next if entry.directory?
          xml = zipfile.read(entry.name)
          begin
            result = import_cat_1(xml, test_id)
            if (result[:status] != 'success')
              raise result[:message]
            end
          rescue Exception => e
            failed_dir = File.join(File.dirname(temp_file.path), 'failed_imports')
            unless(Dir.exists?(failed_dir))
              Dir.mkdir(failed_dir)
            end
            FileUtils.cp(temp_file, failed_dir)
            raise e
          end
        end
      end

      # Delete temp zip
      File.delete(temp_file.path)

      # Initialize parameters
      measure_ids = params[:measure_ids] || current_user.preferences["selected_measure_ids"]
      effective_date = (params[:effective_date].to_i if params[:effective_date]) || current_user.effective_date || Time.gm(2012, 12, 31).to_i
      end_date = Time.at(effective_date)
      start_date = Time.at((params[:start_date].to_i if params[:start_date]) || (end_date.years_ago(1) + 1.day))

      # Initialize filters
      measures_filter = measure_ids=="all" ? {}  : {:hqmf_id.in =>measure_ids.map { |mId| mId.upcase }} #Measure Ids are stored in uppercase

      # Ensure every measure is calculated
      HealthDataStandards::CQM::Measure.where(measures_filter).each do |measure|
        oid_dictionary = OidHelper.generate_oid_dictionary(measure)
        qr = QME::QualityReport.find_or_create(measure.hqmf_id, measure.sub_id, {'effective_date' => effective_date, 'test_id' => test_id})
        qr.calculate({'oid_dictionary' => oid_dictionary, 'recalculate' => true}, false)
      end

      # TODO: generate proper header for providers mentioned in cat 1 files. For now, prepare fake header
      fake_header = generate_header([])

      # Export report
      exporter =  HealthDataStandards::Export::Cat3.new
      qrda_cat3 = exporter.export(HealthDataStandards::CQM::Measure.top_level.where(measures_filter),
                                  fake_header, effective_date.to_i, start_date, end_date, nil, test_id)

      # Cleanup all records associated with test id
      Record.where(test_id: test_id).delete
      QME::QualityReport.where(test_id: test_id).delete
      QME::PatientCache.where('value.test_id' => test_id).delete

      render xml: qrda_cat3, content_type: "attachment/xml"
    end

    private

    def generate_header(provider)
      header = Qrda::Header.new(APP_CONFIG["cda_header"])

      header.identifier.extension = UUID.generate
      header.authors.each {|a| a.time = Time.now}
      header.legal_authenticator.time = Time.now
      header.performers << provider

      header
    end

    # Imports category 1 xml data and saves it for specific test_id
    def import_cat_1(xml_data, test_id)
      doc = Nokogiri::XML(xml_data)

      providers = []
      root_element_name = doc.root.name

      if root_element_name == 'ClinicalDocument'
        doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
        doc.root.add_namespace_definition('sdtc', 'urn:hl7-org:sdtc')

        if doc.at_xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.24.1.2']")
          patient_data = HealthDataStandards::Import::Cat1::PatientImporter.instance.parse_cat1(doc)
        else
          STDERR.puts("Unable to determinate document template/type of CDA document")
          return {status: 'error', message: "Document templateId does not identify it as a C32 or CCDA", status_code: 400}
        end

        begin
          providers = HealthDataStandards::Import::CDA::ProviderImporter.instance.extract_providers(doc)
        rescue Exception => e
          STDERR.puts "error extracting providers"
        end
      else
        return {status: 'error', message: 'Unknown XML Format', status_code: 400}
      end

      record = update_or_create_record(patient_data, test_id)
      record.provider_performances = providers
      providers.each do |prov|
        prov.provider.ancestors.each do |ancestor|
          record.provider_performances.push(ProviderPerformance.new(start_date: prov.start_date, end_date: prov.end_date, provider: ancestor))
        end
      end
      record.save

      {status: 'success', message: 'patient imported', status_code: 201, record: record}

    end

    def update_or_create_record(data, test_id)
      data.test_id = test_id
      existing = Record.where(medical_record_number: data.medical_record_number).where(test_id: data.test_id).first
      if existing
        existing.update_attributes!(data.attributes.except('_id'))
        existing
      else
        data.save!
        data
      end
    end
  end
end
