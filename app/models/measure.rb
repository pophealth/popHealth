class Measure < MongoBase
  
  def self.sub_measures(measure_id)
    mongo['measures'].find("id" => measure_id)
  end
  
  def self.get(id, sub_id)
    mongo['measures'].find({'id' => id, 'sub_id' => sub_id})
  end
  
  # Finds all measures by category
  # @return Array - This returns an Array of Hashes. Each Hash will have a category property for
  #         the name of the category. It will also have a measures property which will be
  #         another Array of Hashes. The sub hashes will have the name and id of each measure.
  def self.all_by_category
    mongo['measures'].group(:key => :category,
                            :initial => {:measures => []},
                            :reduce =>
                            'function(obj,prev) {
                                  var measureIds = [];
                                  for (var i = 0; i < prev.measures.length; i++) {
                                    measureIds.push(prev.measures[i].id)
                                  }
                                  if (contains(measureIds, obj.id) == false) {
                                    prev.measures.push({"id": obj.id, "name": obj.name});
                                  }
                             };')
  end
  
  # Finds all measures by category, except for core and core alternate measures
  # @return Array - This returns an Array of Hashes. Each Hash will have a category property for
  #         the name of the category. It will also have a measures property which will be
  #         another Array of Hashes. The sub hashes will have the name and id of each measure.
  def self.non_core_measures
    mongo['measures'].group(:key => :category, 
                            :cond => {:category => {"$nin" => ['Core', 'Core Alternate']}},
                            :initial => {:measures => []},
                            :reduce =>
                            'function(obj,prev) {
                                  var measureIds = [];
                                  for (var i = 0; i < prev.measures.length; i++) {
                                    measureIds.push(prev.measures[i].id)
                                  }
                                  if (contains(measureIds, obj.id) == false) {
                                    prev.measures.push({"id": obj.id, "name": obj.name, "description": obj.description});
                                  }
                                  
                             };')
  end
  
  # Finds all core measures
  # @return Array - This returns an Array of Hashes. Each Hash will have the name and id of each measure.
  def self.core_measures
    mongo['measures'].group(:key => [:id, :name, :description], 
                            :cond => {:category => 'Core'},
                            :initial => {:subs => [], 'short_subtitles' => {}},
                            :reduce => 
                            'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id); prev.short_subtitles[obj.sub_id] = obj.short_subtitle; }}')
  end
  
  # Finds all core alternate measures
  # @return Array - This returns an Array of Hashes. Each Hash will have the name and id of each measure.
  def self.core_alternate_measures
    mongo['measures'].group(:key => [:id, :name, :description], 
                            :cond => {:category => 'Core Alternate'},
                            :initial => {:subs => [], 'short_subtitles' => {}},
                            :reduce => 'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id); prev.short_subtitles[obj.sub_id] = obj.short_subtitle; }}')
  end
  
  # Finds all measures and groups the sub measures
  # @return Array - This returns an Array of Hashes. Each Hash will have a name property for
  #         the name of the measure as well and an id for each mesure. It will also have a subs
  #         property which will be an array of sub ids.
  def self.all_by_measure
    mongo['measures'].group(:key => [:id, :name],
                            :initial => {:subs => [], 'short_subtitles' => {}},
                            :reduce => 'function(obj,prev) {
                                          if (obj.sub_id != null) {
                                            prev.subs.push(obj.sub_id);
                                            prev.short_subtitles[obj.sub_id] = obj.short_subtitle
                                          }
                                          
                                        }')
  end
  
  # 
  def self.alternate_measures
    mongo['measures'].group(:key => [:id, :name, :description], 
                            :cond => {:category => {"$nin" => ['Core', 'Core Alternate']}},
                            :initial => {:subs => [], 'short_subtitles' => {}},
                            :reduce => 'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id); prev.short_subtitles[obj.sub_id] = obj.short_subtitle; }}')
  end

  # Adds a measure to the selected_measure collection. It copies some of the measure information
  # from the measure collection
  # @param [String] measure_id the id of the measure to select
  # @param [String] username name of the user who this selected measure will belong
  # @return [Hash] representing the added measure. nil if the measure is already selected or if the
  #                measure id provided does not match any measures
  def self.add_measure(username, measure_id)
    if mongo['selected_measures'].find_one(:id => measure_id, :username => username)
      return nil
    else
      measures = mongo['measures'].find(:id => measure_id)

      if measures
        selected_measure_doc = {'subs' => [], 'short_subtitles' => {}}
        measures.each do |measure|
          selected_measure_doc['username'] = username
          selected_measure_doc['id'] = measure['id']
          selected_measure_doc['name'] = measure['name']
          selected_measure_doc['category'] = measure['category']
          selected_measure_doc['description'] = measure['description']
          if measure['sub_id']
            selected_measure_doc['subs'] << measure['sub_id']
            selected_measure_doc['short_subtitles'][measure['sub_id']] = measure['short_subtitle']
          end
        end

        mongo['selected_measures'].save(selected_measure_doc)

        return selected_measure_doc
      else
        return nil
      end
    end
  end
  
  def self.remove_measure(username, measure_id)
    mongo['selected_measures'].remove(:id => measure_id, :username => username)
  end
end