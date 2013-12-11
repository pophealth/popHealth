class Record
  include Mongoid::Document
  
  # ===========================================================
  # = This record extends the record in health data standards =
  # ===========================================================
  
  field :measures, type: Hash

  scope :alphabetical, order_by([:last, :asc], [:first, :asc])
  scope :with_provider, where(:provider_performances.ne => nil).or(:provider_proformances.ne => [])
  scope :without_provider, any_of({provider_performances: nil}, {provider_performances: []})
  scope :provider_performance_between, ->(effective_date) { where("provider_performances.start_date" => {"$lt" => effective_date}).and('$or' => [{'provider_performances.end_date' => nil}, 'provider_performances.end_date' => {'$gt' => effective_date}]) }
  
  def self.update_or_create(data)
    existing = Record.where(medical_record_number: data.medical_record_number).first
    if existing
      existing.update_attributes!(data.attributes.except('_id'))
      existing
    else
      data.save!
      data
    end
  end
  
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
  
  
end
