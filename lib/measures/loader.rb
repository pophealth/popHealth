module Measures
  class Loader
    PARSERS = [HQMF::Parser::V2Parser,HQMF::Parser::V1Parser]
    DRAFT_DIRECTORY = "tmp/draft_measures"

    def self.parse_model(xml_path)
      xml_contents = Nokogiri::XML(File.new xml_path)
      parser = get_parser(xml_contents)
      parser.parse(xml_contents)
    end
    
    def self.save_for_finalization(hqmf_model)
      FileUtils.mkdir_p(DRAFT_DIRECTORY)
      file = File.open(File.join(DRAFT_DIRECTORY,"#{hqmf_model.hqmf_id}.json"),"w") do |f|
        f.puts hqmf_model.to_json.to_json
      end
    end

    def self.finalize_measure(hqmf_id,nlm_user=nil,nlm_pass=nil,meta_data={})
     
      json = JSON.parse(File.read(File.join(DRAFT_DIRECTORY,"#{hqmf_id}.json")))
      hqmf_model = HQMF::Document.from_json(json)
      generate_measures(hqmf_model,nlm_user,nlm_pass,meta_data)
    end

    def self.generate_measures(hqmf_model,nlm_user=nil,nlm_pass=nil, meta_data={})
       #delete old measures
       #delete old query cache entries
       #delete old patient cache entries
      existing = HealthDataStandards::CQM::Measure.where({hqmf_id: hqmf_model.hqmf_id}).to_a
      qcache = HealthDataStandards::CQM::QueryCache.where({hqmf_id: hqmf_model.hqmf_id}).or({measure_id: hqmf_model.hqmf_id})
      pcache = HealthDataStandards::CQM::PatientCache.where({"value.hqmf_id" => hqmf_model.hqmf_id}).or({"value.measure_id" => hqmf_model.hqmf_id})
      load_valuesets(hqmf_model,nlm_user,nlm_pass,meta_data["force_update"])
      measures = materialize_measures(hqmf_model,meta_data)
      
      begin
        measures.each do |m|
          m.save!
        end
      rescue => e
        measures.each do |m|
          m.destroy if m.new_record?
        end
        raise e
      end
     
      existing.each do |m|
        m.destroy
      end
      update_system_js
      qcache.destroy
      pcache.destroy 
    end


    def self.load_valuesets(hqmf_document,vsac_user, vsac_pass, force_update=false)

      vsac_config = APP_CONFIG["value_sets"]
      vsac_user ||=vsac_config["nlm_user"]
      vsac_pass ||=vsac_config["nlm_pass"]
      api = HealthDataStandards::Util::VSApi.new(vsac_config["ticket_url"],vsac_config["api_url"],vsac_user,vsac_pass)
      oids = hqmf_document.all_data_criteria.collect{|dc| dc.code_list_id}
      oids.each do |oid|
        exists = HealthDataStandards::SVS::ValueSet.where({oid: oid, bundle_id: nil}).count > 0
        if (!exists || force_update)
          begin
            vs = api.get_valueset(oid)
            doc = Nokogiri::XML(vs)
            HealthDataStandards::SVS::ValueSet.load_from_xml(doc).save
          rescue => e
            raise "Error loading valuesets: #{e}"
          end
        end 
      end
    end

   def self.update_system_js
      HealthDataStandards::Import::Bundle::Importer.save_system_js_fn('map_reduce_utils',
                                                                     HQMF2JS::Generator::JS.map_reduce_utils)
      HealthDataStandards::Import::Bundle::Importer.save_system_js_fn('hqmf_utils',
                                                                  HQMF2JS::Generator::JS.library_functions(false))
   end

    def self.materialize_measures(hqmf_document, meta_data={})
  
      continuous_variable = hqmf_document.populations.map {|x| x.keys}.flatten.uniq.include? HQMF::PopulationCriteria::MSRPOPL
      value_sets = HealthDataStandards::SVS::ValueSet.in(oid: hqmf_document.all_code_set_oids)
      measures = []
      options = {
      value_sets: value_sets,
      episode_ids: meta_data["episode_ids"],
      continuous_variable: continuous_variable
    }
      hqmf_document.populations.each_with_index do |pop,population_index|
        measure = HealthDataStandards::CQM::Measure.new ({
          nqf_id: hqmf_document.id || meta_data["nqf_id"],
          hqmf_id: hqmf_document.hqmf_id,
          hqmf_set_id: hqmf_document.hqmf_set_id,
          hqmf_version_number: hqmf_document.hqmf_version_number,
          cms_id: hqmf_document.cms_id,
          name: hqmf_document.title,
          title: hqmf_document.title,
          description: hqmf_document.description,
          type: meta_data["type"],
          category: meta_data["category"],
          map_fn: HQMF2JS::Generator::Execution.measure_js(hqmf_document, population_index, options),
          continuous_variable: continuous_variable,
          episode_of_care: meta_data["episode_of_care"],
          hqmf_document:  hqmf_document.to_json
        })
        measure.lower_is_better = meta_data["lower_is_better"] 
        measure["id"] = hqmf_document.hqmf_id
        
        if (hqmf_document.populations.count > 1)
          sub_ids = ('a'..'az').to_a
          measure.sub_id = sub_ids[population_index]
          
          measure.subtitle = measure.sub_id
          measure.short_subtitle =  measure.sub_id
        end

        if continuous_variable
          observation = hqmf_document.population_criteria(hqmf_document.populations[population_index][HQMF::PopulationCriteria::OBSERV])
          measure.aggregator = observation.aggregator
        end
        
        measure.oids = value_sets.map{|value_set| value_set.oid}.uniq
        
        population_ids = {}
       
        HQMF::PopulationCriteria::ALL_POPULATION_CODES.each do |type|
          population_key = hqmf_document.populations[population_index][type]
          population_criteria = hqmf_document.population_criteria(population_key)
          if (population_criteria)
            population_ids[type] = population_criteria.hqmf_id
          end
        end
        stratification = hqmf_document.populations[population_index]['stratification']
        if stratification
          population_ids['stratification'] = stratification 
        end
        measure.population_ids = population_ids
        measures << measure
      end
      measures
    end

    def self.get_parser(doc)
      PARSERS.each do |p|
        if p.valid? doc
          return p.new
        end
      end
      raise "unknown document type"
    end

  end
end
