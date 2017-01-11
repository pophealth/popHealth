class Record
  include Mongoid::Document
  
  # ===========================================================
  # = This record extends the record in health data standards =
  # ===========================================================
  
  field :measures, type: Hash
  
  belongs_to :practice
  
  scope :alphabetical, ->{order_by([:last, :asc], [:first, :asc])}
  scope :with_provider, ->{where(:provider_performances.ne => nil).or(:provider_proformances.ne => [])}
  scope :without_provider, ->{any_of({provider_performances: nil}, {provider_performances: []})}
  scope :provider_performance_between, ->(effective_date) { where("provider_performances.start_date" => {"$lt" => effective_date}).and('$or' => [{'provider_performances.end_date' => nil}, 'provider_performances.end_date' => {'$gt' => effective_date}]) }
    
  Valid_Sections = [:allergies, :conditions, :encounters, :immunizations, :medications, :procedures, :results, :vital_signs, :socialhistories]
    
  def language_names
    lang_codes = (languages.nil?) ? [] : languages.map { |l| l.gsub(/\-[A-Z]*$/, "") }
    Language.ordered.by_code(lang_codes).map(&:name)
  end

  def cache_results(params = {})
    query = {"value.medical_record_id" => self.medical_record_number }
    query["value.effective_date"]= params["effective_date"] if params["effective_date"]
    query["value.effective_start_date"]= params["effective_start_date"] if params["effective_start_date"]
    query["value.measure_id"]= params["measure_id"] if params["measure_id"]
    query["value.sub_id"]= params["sub_id"] if params["sub_id"]
    HealthDataStandards::CQM::PatientCache.where(query)
  end
  
  def self.update_or_create(data, practice_id=nil)
    mrn = data.medical_record_number
    mrn_p = (practice_id)? mrn + "_pid_" + practice_id : ''
    if practice_id
      existing = Record.where(medical_record_number: mrn_p).first
    else
      existing = Record.where(medical_record_number: mrn).first
    end

    if existing
      existing.update_attributes!(data.attributes.except('_id', 'medical_record_number', 'practice_id'))
      
      # updates
      Record::Valid_Sections.each do |section|        
        if ! data.send(section).blank?
          query = {}
          query = {medical_record_number: existing.medical_record_number, section => {'$elemMatch' => {}}}

          data.send(section).each do |entry|          
                   
            if entry.status_code
              query[section]['$elemMatch']['status_code'] = entry.status_code
            end
            
            if entry.time
              query[section]['$elemMatch']['time'] = entry.time
            elsif entry.start_time
              query[section]['$elemMatch']['start_time'] = entry.start_time
            end
                       
            if entry.end_time
              query[section]['$elemMatch']['end_time'] = entry.end_time
            end

            if entry.cda_identifier.root
              query[section]['$elemMatch']['cda_identifier.root'] = entry.cda_identifier.root
            end

            if entry.cda_identifier.extension
              query[section]['$elemMatch']['cda_identifier.extension'] = entry.cda_identifier.extension
            end
            
            exists = Record.where(query).first
            if ! exists 
              existing.send(section).push(entry)
            end
          end
        end
      end
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
  
end
