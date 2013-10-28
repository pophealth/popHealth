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
    #doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    providers = []
    root_element_name = doc.root.name
    
    if root_element_name == 'ClinicalDocument'
      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')

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
      
     	begin
        providers = HealthDataStandards::Import::CDA::ProviderImporter.instance.extract_providers(doc)
      rescue Exception => e
        STDERR.puts "error extracting providers"
      end

    # Disabling this until HDS is updated or QRDA Importer is done @SS
    # elsif root_element_name == 'ContinuityOfCareRecord'
    #   doc.root.add_namespace_definition('ccr', 'urn:astm-org:CCR')
    #   patient_id_xpath = "./ccr:IDs/ccr:ID[../ccr:Type/ccr:Text=\"#{APP_CONFIG['ccr_system_name']}\"]"
    #   patient_data = HealthDataStandards::Import::CCR::PatientImporter.instance.parse_ccr(doc, patient_id_xpath)
    #   begin
    #     providers = HealthDataStandards::Import::CCR::ProviderImporter.instance.extract_providers(doc)
    #   rescue Exception => e
    #     STDERR.puts "error extracting providers"
    #   end
    #   binding.pry 
    else
      return {status: 'error', message: 'Unknown XML Format', status_code: 400}
    end

    record = Record.update_or_create(patient_data)
    record.provider_performances = providers
    record.save
    
    {status: 'success', message: 'patient imported', status_code: 201, record: record}
    
  end

end
