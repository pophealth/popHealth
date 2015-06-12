require 'fileutils'

class BulkRecordImporter < HealthDataStandards::Import::BulkRecordImporter
  def initialize
    super
  end 
  
  def self.import_archive(file, failed_dir=nil, practice=nil)
    begin
    failed_dir ||=File.join(File.dirname(file))

    patient_id_list = nil

    Zip::ZipFile.open(file.path) do |zipfile|
      zipfile.entries.each do |entry|
        if entry.name
          if entry.name.split("/").last == "patient_manifest.txt"
            patient_id_list = zipfile.read(entry.name)
            next
          end
        end
        next if entry.directory?
        data = zipfile.read(entry.name)
        self.import_file(entry.name,data,failed_dir,nil,practice)
      end
    end

    missing_patients = []

    #if there was a patient manifest, theres a patient id list we need to load
    if patient_id_list
      patient_id_list.split("\n").each do |id|
        patient = Record.where(:medical_record_number => id).first
        if patient == nil
          missing_patients << id
        end
      end
    end

    missing_patients

  rescue
    FileUtils.mkdir_p(failed_dir)
    FileUtils.cp(file,File.join(failed_dir,File.basename(file)))
    File.open(File.join(failed_dir,"#{file}.error")) do |f|
      f.puts($!.message)
      f.puts($!.backtrace)
    end
    raise $!
  end
  end

  def self.import_file(name,data,failed_dir,provider_map={}, practice=nil)
    begin
      ext = File.extname(name)
      if ext == ".json"
        self.import_json(data)
      else
        self.import(data, {}, practice)
      end
    rescue
      FileUtils.mkdir_p(File.dirname(File.join(failed_dir,name)))
      File.open(File.join(failed_dir,name),"w") do |f|
        f.puts(data)
      end
      File.open(File.join(failed_dir,"#{name}.error"),"w") do |f|
        f.puts($!.message)
        f.puts($!.backtrace)
      end
    end
  end

  def self.import(xml_data, provider_map = {}, practice_id=nil)
    doc = Nokogiri::XML(xml_data)

    providers = []
    root_element_name = doc.root.name

    if root_element_name == 'ClinicalDocument'
      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
      doc.root.add_namespace_definition('sdtc', 'urn:hl7-org:sdtc')

      if doc.at_xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.3.88.11.32.1']")
        patient_data = HealthDataStandards::Import::C32::PatientImporter.instance.parse_c32(doc)
      elsif doc.at_xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.22.1.2']")
        patient_data = HealthDataStandards::Import::CCDA::PatientImporter.instance.parse_ccda(doc)
      elsif doc.at_xpath("/cda:ClinicalDocument/cda:templateId[@root='2.16.840.1.113883.10.20.24.1.2']")
        patient_data = HealthDataStandards::Import::Cat1::PatientImporter.instance.parse_cat1(doc)
      else
        STDERR.puts("Unable to determinate document template/type of CDA document")
        return {status: 'error', message: "Document templateId does not identify it as a C32 or CCDA", status_code: 400}
      end

      record = Record.create_or_replace(patient_data, practice_id)

      begin
        providers = HealthDataStandards::Import::CDA::ProviderImporter.instance.extract_providers(doc, record)
      rescue Exception => e
        STDERR.puts "error extracting providers"
      end
    else
      return {status: 'error', message: 'Unknown XML Format', status_code: 400}
    end

    if practice_id
      practice = Practice.find(practice_id)
      practice_provider = practice.provider
      
      npi_providers = providers.map {|perf| perf}
      name = practice.name + " Unassigned"
      cda_identifier = CDAIdentifier.new({root: APP_CONFIG['orphan_provider']['root'], extension: name})
      providers.each do |perf|
        prov = perf.provider
        if prov.cda_identifiers.first.extension == 'Orphans'          
          orphan_provider = Provider.where("cda_identifiers.extension" => name).first
          if orphan_provider   
            new_prov = orphan_provider
          else             
            new_prov = Provider.create(cda_identifiers: [cda_identifier], given_name: name)
            new_prov.parent = practice_provider
            new_prov.save!
          end
          npi_providers.delete(perf)
          npi_providers << ProviderPerformance.new(start_date: perf.start_date, end_date: perf.end_date, provider: new_prov)  
        else
          if prov.parent == nil
            prov.parent = practice_provider
            prov.save!
          elsif prov.parent.id == practice_provider.id
            next
          else
            prov_check = Provider.where({'cda_identifiers.extension' => prov.cda_identifiers.first.extension, parent_id: practice_provider.id}).first
            if prov_check
              npi_providers.delete(perf)
              npi_providers << ProviderPerformance.new(start_date: perf.start_date, end_date: perf.end_date, provider: prov_check)
            else            
              new_prov = prov.clone
              new_prov.parent = practice_provider
              new_prov.save
              npi_providers.delete(perf)
              npi_providers << ProviderPerformance.new(start_date: perf.start_date, end_date: perf.end_date, provider: new_prov)
            end
          end
        end
      end
      
      # if no providers assigned, then assign to orphan
      if npi_providers.empty?
        orphan_provider = Provider.where("cda_identifiers.extension" => name).first
        if orphan_provider
          new_prov = orphan_provider
        else             
          new_prov = Provider.create(cda_identifiers: [cda_identifier], given_name: name)
          new_prov.parent = practice_provider
          new_prov.save!
        end
        npi_providers << ProviderPerformance.new(provider: new_prov)
      end
      record.provider_performances = npi_providers
      
      orphan_prov = Provider.where("cda_identifiers.extension" => "Orphans").first
      if orphan_prov
        prov = orphan_prov
        prov.parent = nil
        prov.parent_ids = nil
        prov.save!
      end
      providers = npi_providers
    else # if no practice, use regular assignment
      record.provider_performances = providers
    end
    providers.each do |prov|
      prov.provider.ancestors.each do |ancestor|
        record.provider_performances.push(ProviderPerformance.new(start_date: prov.start_date, end_date: prov.end_date, provider: ancestor))
      end
    end

    record.save
  end
end
