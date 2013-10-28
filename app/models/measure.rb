class Measure

  GROUP = {'$group' => {_id: "$id", 
                        name: {"$first" => "$name"},
                        description: {"$first" => "$description"},
                        sub_ids: {'$push' => "$sub_id"},
                        subs: {'$push' => {"sub_id" => "$sub_id", "short_subtitle" => "$short_subtitle"}},
                        category: {'$first' => "$category"}}}

  CATEGORY = {'$group' => {_id: "$category",
                           measures: {'$push' => {"id" => "$_id", 
                                                  'name' => "$name",
                                                  'description' => "$description",
                                                  'subs' => "$subs",
                                                  'sub_ids' => "$sub_ids"
                                                  }}}}

  ID = {'$project' => {'category' => '$_id', 'measures' => 1, '_id' => 0}}
  
  SORT = {'$sort' => {"category" => 1}}

  def self.all
    MONGO_DB['measures'].find({})
  end

  def self.categories
    aggregate(GROUP, CATEGORY, ID, SORT)
  end
	
  def self.list
    aggregate({'$project' => {'id' => 1, 'sub_id' => 1, 'name' => 1, 'short_subtitle' => 1}})
  end

  private

  def self.aggregate(*pipeline)
    Mongoid.default_session.command(aggregate: 'measures', pipeline: pipeline)['result']
  end

end
