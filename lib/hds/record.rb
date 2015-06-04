class Record
  include Mongoid::Document
  
  # ===========================================================
  # = This record extends the record in health data standards =
  # ===========================================================
  
  field :measures, type: Hash
  
  belongs_to :practice, dependent: :destroy
  
  scope :alphabetical, ->{order_by([:last, :asc], [:first, :asc])}
  scope :with_provider, ->{where(:provider_performances.ne => nil).or(:provider_proformances.ne => [])}
  scope :without_provider, ->{any_of({provider_performances: nil}, {provider_performances: []})}
  scope :provider_performance_between, ->(effective_date) { where("provider_performances.start_date" => {"$lt" => effective_date}).and('$or' => [{'provider_performances.end_date' => nil}, 'provider_performances.end_date' => {'$gt' => effective_date}]) }
    
  def language_names
    lang_codes = (languages.nil?) ? [] : languages.map { |l| l.gsub(/\-[A-Z]*$/, "") }
    Language.ordered.by_code(lang_codes).map(&:name)
  end

  def cache_results(params = {})
    query = {"value.medical_record_id" => self.medical_record_number }
    query["value.effective_date"]= params["effective_date"] if params["effective_date"]
    query["value.measure_id"]= params["measure_id"] if params["measure_id"]
    query["value.sub_id"]= params["sub_id"] if params["sub_id"]
    HealthDataStandards::CQM::PatientCache.where(query)
  end
  
  def self.update_or_create(data, practice_id=nil)
    mrn = data.medical_record_number
    mrn_p = (practice_id)? mrn + "-" + Practice.all.map{|i| i.id.to_s}.index(practice_id).to_s : ''
    if practice_id
      existing = Record.where(medical_record_number: mrn_p).first
    else
      existing = Record.where(medical_record_number: mrn).first
    end

    if existing
      existing.update_attributes!(data.attributes.except('_id', 'medical_record_number', 'practice_id'))
      existing
    else
      if practice_id 
        data.practice = Practice.find(practice_id)
        data.medical_record_number = mrn_p
      end
      data.save!
      data
    end
  end
  
  def self.create_or_replace(data, practice_id=nil)
    mrn = data.medical_record_number
    mrn_p = (practice_id)? mrn + "-" + Practice.all.map{|i| i.id.to_s}.index(practice_id).to_s : ''
    if practice_id
      existing = Record.where(medical_record_number: mrn_p).first
      if existing && data.effective_time > existing.effective_time
        existing.destroy
        data.practice = Practice.find(practice_id)
        data.medical_record_number = mrn_p
        data.save!
        data
      elsif existing
        existing  
      else
        data.practice = Practice.find(practice_id)
        data.medical_record_number = mrn_p
        data.save!
        data        
      end
    else
      existing = Record.where(medical_record_number: mrn).first
      if existing && data.effective_time > existing.effective_time
        existing.destroy
        data.save!
        data
      elsif existing
        existing  
      else
        data.save!
        data        
      end
    end
  end  
end
