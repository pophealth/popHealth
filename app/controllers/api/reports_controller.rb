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
    param :generation_params, String, :desc => 'JSON object specifying start_date (since epoch in seconds), effective_date (since epoch in seconds) and measure_ids (the HQMF ID of the measures to include in the document)', :required => false
    param :cat1_zip, :desc => 'Zip archive of patient QRDA Category 1 files for measures requested', :required => true
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
      Zip::ZipFile.open(file.path) do |zipfile|
        zipfile.entries.each do |entry|
          next if entry.directory?
          xml = zipfile.read(entry.name)
          begin
            result = HealthDataStandards::Import::BulkRecordImporter.import(xml)
            if (result[:status] == 'success')
              # Mark records with test id
              record = result[:record]
              record.test_id = test_id
              record.save
            else
              assert result[:message]
            end
          rescue Exception => e
            failed_dir = File.join(file.dirname, 'failed_imports')
            unless(Dir.exists?(failed_dir))
              Dir.mkdir(failed_dir)
            end
            FileUtils.cp(file, failed_dir)
          end
        end
      end

      # Initialize parameters
      generation_params = JSON.parse(params[:generation_params])
      measure_ids = generation_params['measure_ids'] || current_user.preferences["selected_measure_ids"]
      effective_date = generation_params['end_date'] || current_user.effective_date || Time.gm(2012, 12, 31)
      end_date = Time.at(effective_date.to_i)
      start_date = Time.at(generation_params['start_date'] || (end_date.years_ago(1) + 1.day))

      # Initialize filters
      measures_filter = measure_ids=="all" ? {}  : {:hqmf_id.in =>measure_ids.map { |mId| mId.upcase }} #Measure Ids are stored in uppercase

      # Ensure every measure is calculated
      HealthDataStandards::CQM::Measure.where(measures_filter).each do |measure|
        oid_dictionary = OidHelper.generate_oid_dictionary(measure)
        qr = QME::QualityReport.find_or_create(measure.hqmf_id, measure.sub_id, {'effective_date' => effective_date, 'test_id' => test_id})
        qr.calculate({'oid_dictionary' => oid_dictionary}, false) unless qr.calculated?
      end

      # Export report
      exporter =  HealthDataStandards::Export::Cat3.new
      qrda_cat3 = exporter.export(HealthDataStandards::CQM::Measure.top_level.where(measures_filter),
                                  generate_header(provider),
                                  effective_date.to_i, start_date, end_date,
                                  nil, test_id)

      render xml: qrda_cat3, content_type: "attachment/xml"
    end

    private

    def generate_header(provider)
      header = Qrda::Header.new(APP_CONFIG["cda_header"])

      header.identifier.root = UUID.generate
      header.authors.each {|a| a.time = Time.now}
      header.legal_authenticator.time = Time.now
      header.performers << provider

      header
    end
  end
end
