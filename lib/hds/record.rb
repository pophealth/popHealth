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

	# added from bstrezze 
  def self.provider_in(provider_list) 
    any_in("provider_performances.provider_id" => provider_list)
  end

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
  
  
end
