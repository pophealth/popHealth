class Measure < MongoBase

  # Finds all measures by category
  # @return Array - This returns an Array of Hashes. Each Hash will have a category property for
  #         the name of the category. It will also have a measures property which will be
  #         another Array of Hashes. The sub hashes will have the name and id of each measure.
  def self.all_by_category
    mongo['measures'].group([:category], nil,
                            {:measures => []},
                            'function(obj,prev) {prev.measures.push({"id": obj.id, "name": obj.name})}')
  end
  
  # Finds all measures and groups the sub measures
  # @return Array - This returns an Array of Hashes. Each Hash will have a name property for
  #         the name of the measure as well and an id for each mesure. It will also have a subs
  #         property which will be an array of sub ids.
  def self.all_by_measure
    mongo['measures'].group([:id, :name], nil,
                            {:subs => []},
                            'function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id);}}')
  end
end