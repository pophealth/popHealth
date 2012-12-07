class ManualExclusion
  include Mongoid::Document
  
  store_in collection: :manual_exclusions
  
  field :measure_id, type: String
  field :sub_id, type: String
  field :medical_record_id, type: String
  field :rationale, type: String
  field :created_at, type: Date
  belongs_to :user
  
  scope :selected, ->(medical_record_ids) { any_in(:medical_record_id => medical_record_ids)}
  scope :for_record, ->(patient) {where("medical_record_id" => patient.medical_record_number)}

  def self.toggle!(patient, measure_id, sub_id, rationale, user)
    existing = ManualExclusion.where({:medical_record_id => patient.medical_record_number}).and({:measure_id => measure_id}).and({:sub_id => sub_id}).first

    if existing
      Log.create(:username => user.username, :event => 'manual exclusion revoked', :description => rationale, :medical_record_number => patient.medical_record_number)
      
      existing.destroy
      MONGO_DB['patient_cache'].find({'value.measure_id'=>measure_id, 'value.sub_id'=>sub_id, 'value.medical_record_id'=>patient.medical_record_number }).update({'$set'=>{'value.manual_exclusion'=>false}}, :multi=>true)
    else
      Log.create(:username => user.username, :event => 'manual exclusion envoked', :description => rationale, :medical_record_number => patient.medical_record_number)
      ManualExclusion.create!({:medical_record_id => patient.medical_record_number, :measure_id => measure_id, :sub_id => sub_id, :rationale => rationale, user: user, created_at: Time.now})
      MONGO_DB['patient_cache'].find({'value.measure_id'=>measure_id, 'value.sub_id'=>sub_id, 'value.medical_record_id'=>patient.medical_record_number }).update({'$set'=>{'value.manual_exclusion'=>true}}, :multi=>true)
    end
    QueryCache.where({:measure_id => measure_id}).and({:sub_id => sub_id}).destroy_all
  end
end
