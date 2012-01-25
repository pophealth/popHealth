require 'fileutils'
class RecordImporter
  
  def initialize(source_dir, providers_predefined)
    @source_dir = source_dir
    @providers_predefined = providers_predefined
  end
  
  def run
    
    provider_map = {}
    if (@providers_predefined)
      Provider.all.each {|provider| provider_map[provider.npi] = provider}
    end
    
    count=0
    xml_files = Dir.glob(File.join(@source_dir, '*.*'))
    total = xml_files.count
    xml_files.each do |file|
      count+=1

      begin
        
        result = RecordImporter.import(File.new(file).read, provider_map)
        
        if (result[:status] == 'success') 
          record = result[:record]
          record.save
        else 
          assert result[:message]
        end
        
      rescue Exception => e
        puts "processing failed!! (#{file})"
        puts e.inspect
        failed_dir = File.join(@source_dir, '../', 'failed_imports')
        puts "writing failure to: #{failed_dir}"
        unless(Dir.exists?(failed_dir))
          Dir.mkdir(failed_dir)
        end
        FileUtils.cp(file, failed_dir)
      end

      puts "imported: #{count} of #{total} records" if count%100==0
    end
    puts "Complete... Imported #{count} of #{total} patient records"
    
  end
  
  def self.import(xml_data, provider_map = {})
    doc = Nokogiri::XML(xml_data)
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    providers = []
    root_element_name = doc.root.name

    if root_element_name == 'ClinicalDocument'
      patient_data = HealthDataStandards::Import::C32::PatientImporter.instance.parse_c32(doc)
      providers = QME::Importer::ProviderImporter.instance.extract_providers(doc)
    elsif root_element_name == 'ContinuityOfCareRecord'
      if RUBY_PLATFORM =~ /java/
        ccr_importer = CCRImporter.instance
        patient_raw_json = ccr_importer.create_patient(xml_file)
        patient_data = JSON.parse(patient_raw_json)
      else
        return {status: 'error', message: 'CCR Support is currently disabled', status_code: 500}
      end
    else
      return {status: 'error', message: 'Unknown XML Format', status_code: 400}
    end

    patient_data.measures = QME::Importer::MeasurePropertiesGenerator.instance.generate_properties(patient_data)
    record = Record.update_or_create(patient_data)

    providers.each do |pv|
      performance = ProviderPerformance.new(start_date: pv.delete(:start), end_date: pv.delete(:end), record: record)
      # check to see if we have passed in the provider
      if (provider_map[pv[:npi]])
        provider = provider_map[pv[:npi]]
      else
        provider = Provider.merge_or_build(pv)
        provider.save
      end
      if (provider)
        performance.provider = provider
        performance.save
      else
        STDERR.puts "loading provider information failed"
      end
    end
    
    {status: 'success', message: 'patient imported', status_code: 201, record: record}
    
  end

end
