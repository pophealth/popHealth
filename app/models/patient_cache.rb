class PatientCache
  include Mongoid::Document
  
  store_in collection: :patient_cache
  
  field :first, type: String
  field :last, type: String
  field :patient_id, type: String
  field :birthdate, type: Integer
  field :gender, type: String
  
  scope :by_provider, ->(provider, effective_date) { where({'value.provider_performances.provider_id' => provider.id, 'value.effective_date'=>effective_date}) }
  scope :outliers, ->(patient) {where({'value.patient_id'=>patient.id})}

  MATCH = {'$match' => {'value.measure_id' => "8A4D92B2-397A-48D2-0139-9BB3331F4C02", "value.sub_id" => "a"}} 

  SUM = {'$group' => {
          "_id" => "$value.measure_id", # we don't really need this, but Mongo requires that we group 
          "population" => {"$sum" => "$value.population"}, 
          "denominator" => {"$sum" => "$value.denominator"},
          "numerator" => {"$sum" => "$value.numerator"},
          "antinumerator" => {"$sum" => "$value.antinumerator"},
          "exclusions" => {"$sum" => "$value.exclusions"},
          "denexcep" => {"$sum" => "$value.denexcep"},
          "considered" => {"$sum" => 1}
        }}

  REWIND = {'$group' => {"_id" => "$_id", "value" => {"$first" => "$value"}}}

  def self.provider

    aggregate({"$match"=>
   {"value.measure_id"=>"8A4D92B2-3A00-2A25-013A-23015AD43373",
    "value.sub_id"=>nil,
    "value.effective_date"=>1293840000,
    "value.test_id"=>nil,
    "value.manual_exclusion"=>{"$in"=>[nil, false]}}},
 {"$project"=>
   {"value"=>1, "providers"=>"$value.provider_performances.provider_id"}},
 {"$unwind"=>"$providers"},
 {"$match"=>
   {"$or"=>
     [{"providers"=> Moped::BSON::ObjectId("50a64aa68898e5b4b2000001")},
      {"providers"=> Moped::BSON::ObjectId("50a64aa68898e5b4b2000003")},
      {"providers"=> Moped::BSON::ObjectId("50a55a8e8898e5d400000005")},
      {"providers"=> Moped::BSON::ObjectId("50a64aa68898e5b4b2000007")},
      {"providers"=> Moped::BSON::ObjectId("50a64aa68898e5b4b2000009")}]}})
  end

  def self.languages
    # aggregate({'$project' => {'value' => 1, 'languages' => "$value.languages"}},
    #           {'$unwind' => "$languages"},
    #           {'$project' => {'value' => 1, 'languages' => {'$substr' => ['$languages', 0, 2]}}},
    #           {'$match' => {'$or' => [{'languages' => "en"}, {'languages' => "fr"}]}},
    #           REWIND}
    # )
  end

  def self.aggregate(*pipeline)
    Mongoid.default_session.command(aggregate: 'patient_cache', pipeline: pipeline)['result']
  end
end
