class Record
  include Mongoid::Document
  
  # ===========================================================
  # = This record extends the record in health data standards =
  # ===========================================================
  
  field :measures, type: Hash

  scope :alphabetical, ->{order_by([:last, :asc], [:first, :asc])}
  scope :with_provider, ->{where(:provider_performances.ne => nil).or(:provider_proformances.ne => [])}
  scope :without_provider, ->{any_of({provider_performances: nil}, {provider_performances: []})}
  scope :provider_performance_between, ->(effective_date) { where("provider_performances.start_date" => {"$lt" => effective_date}).and('$or' => [{'provider_performances.end_date' => nil}, 'provider_performances.end_date' => {'$gt' => effective_date}]) }
    
  Valid_Sections = [:allergies, :conditions, :encounters, :immunizations, :medications, :procedures, :results, :vital_signs]
  
    
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
  
  def self.update_or_create(data)
    existing = Record.where(medical_record_number: data.medical_record_number).first
    
    if existing
    	#update
      existing.update_attributes!(data.attributes.except('_id'))

      Record::Valid_Sections.each do |section|
        if data.send(section) != [] || data.send(section) != nil
          data.send(section).each do |entry|
            if entry.time
              exists = Record.where( medical_record_number: existing.medical_record_number, section => {'$elemMatch' => {codes: entry.codes, time: entry.time}}).first
            elsif entry.start_time
              exists = Record.where( medical_record_number: existing.medical_record_number, section => {'$elemMatch' => {codes: entry.codes, start_time: entry.start_time}}).first
            else
              exists = Record.where( medical_record_number: existing.medical_record_number, section => {'$elemMatch' => {codes: entry.codes}}).first
            end
            existing.send(section).push(entry) unless exists 
          end
        end
      end

      existing
    else
    	# create
      data.save!
      data
    end
  end
  
end
