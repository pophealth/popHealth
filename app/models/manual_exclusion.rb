class ManualExclusion
  include Mongoid::Document
  
  store_in :manual_exclusions
  
  field :measure_id, type: String
  field :sub_id, type: String
  field :medical_record_id, type: String

  def self.toggle!(patient_id, measure_id, sub_id)
    existing = ManualExclusion.where({:medical_record_id => patient_id}).and({:measure_id => measure_id}).and({:sub_id => sub_id}).first
    if existing
      existing.destroy
      MongoBase.mongo.collection('patient_cache').update(
          {'value.measure_id'=>measure_id, 'value.sub_id'=>sub_id, 'value.medical_record_id'=>patient_id },
          {'$set'=>{'value.manual_exclusion'=>false}}, :multi=>true)
    else
      ManualExclusion.create!({:medical_record_id => patient_id, :measure_id => measure_id, :sub_id => sub_id})
      MongoBase.mongo.collection('patient_cache').update(
          {'value.measure_id'=>measure_id, 'value.sub_id'=>sub_id, 'value.medical_record_id'=>patient_id },
          {'$set'=>{'value.manual_exclusion'=>true}}, :multi=>true)
    end
#    executor = QME::MapReduce::Executor.new(measure_id, sub_id, {})
#    executor.apply_manual_exclusions
    QueryCache.where({:measure_id => measure_id}).and({:sub_id => sub_id}).destroy_all
  end
end
