class Measure < MongoBase

  # Finds all measures by category
  # @return Array - This returns an Array of Hashes. Each Hash will have a category property for
  #         the name of the category. It will also have a measures property which will be
  #         another Array of Hashes. The sub hashes will have the name and id of each measure.
  def self.all_by_category
    mongo['measures'].group(:key => :category,
                            :initial => {:measures => []},
                            :reduce =>
                            'function(obj,prev) { 
                                  if (_.any(prev.measures, function(item){return item.id == obj.id}) == false) {
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
                                  if (_.any(prev.measures, function(item){return item.id == obj.id}) == false) {
                                    prev.measures.push({"id": obj.id, "name": obj.name});
                                  }
                             };')
  end
  
  # Finds all core measures
  # @return Array - This returns an Array of Hashes. Each Hash will have the name and id of each measure.
  def self.core_measures
    mongo['measures'].group(:key => [:id, :name], 
                            :cond => {:category => 'Core'},
                            :initial => {:subs => []},
                            :reduce => 
                            'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id);}}')
  end
  
  # Finds all core alternate measures
  # @return Array - This returns an Array of Hashes. Each Hash will have the name and id of each measure.
  def self.core_alternate_measures
    mongo['measures'].group(:key => [:id, :name], 
                            :cond => {:category => 'Core Alternate'},
                            :initial => {:subs => []},
                            :reduce => 'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id);}}')
  end
  
  # Finds all measures and groups the sub measures
  # @return Array - This returns an Array of Hashes. Each Hash will have a name property for
  #         the name of the measure as well and an id for each mesure. It will also have a subs
  #         property which will be an array of sub ids.
  def self.all_by_measure
    mongo['measures'].group(:key => [:id, :name],
                            :initial => {:subs => []},
                            :reduce => 'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id);}}')
  end

  # Adds a measure to the selected_measure collection. It copies some of the measure information
  # from the measure collection
  # @param [String] measure_id the id of the measure to select
  # @return [Hash] representing the added measure. nil if the measure is already selected or if the
  #                measure id provided does not match any measures
  def self.add_measure(measure_id)
    if mongo['selected_measures'].find_one(:id => measure_id)
      return nil
    else
      measures = mongo['measures'].find(:id => measure_id)

      if measures
        selected_measure_doc = {'subs' => []}
        measures.each do |measure|
          selected_measure_doc['id'] = measure['id']
          selected_measure_doc['name'] = measure['name']
          selected_measure_doc['category'] = measure['category']
          selected_measure_doc['description'] = measure['description']
          if measure['sub_id']
            selected_measure_doc['subs'] << measure['sub_id']
          end
        end

        mongo['selected_measures'].save(selected_measure_doc)

        return selected_measure_doc
      else
        return nil
      end
    end
  end
  
  def self.remove_measure(measure_id)
    mongo['selected_measures'].remove(:id => measure_id)
  end
end