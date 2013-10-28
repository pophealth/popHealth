class Provider
  include Mongoid::Document
  
  scope :alphabetical, order_by([:family_name, :asc], [:given_name, :asc])
  scope :with_npi, where(:npi.ne => nil).or(:npi.ne => "")
  scope :without_npi, any_of({npi: nil}, {npi: ""})
  scope :by_npi, ->(npi) { where(npi: npi) }
  scope :can_merge_with, ->(prov) { prov.npi.blank? ? all_except(prov) : all_except(prov).without_npi }
  scope :all_except, ->(prov) { where(:_id.ne => prov.id) }
  scope :selected, ->(provider_ids) { any_in(:_id => provider_ids)}
  scope :selected_or_all, ->(provider_ids) { provider_ids.nil? || provider_ids.empty? ? Provider.all : Provider.selected(provider_ids) }
  
  
	# added from bstrezze
  def self.userfilter(current_user)
    if current_user.admin?
      Provider.all
    else
      Provider.any_in(:team_id => current_user.teams)
    end
  end 

  belongs_to :team
  
  Specialties = {"100000000X" => "Behavioral Health and Social Service Providers",
                 "110000000X" => "Chiropractic Providers",
                 "120000000X" => "Dental Providers",
                 "130000000X" => "Dietary and Nutritional Service Providers",
                 "140000000X" => "Emergency Medical Service Providers",
                 "150000000X" => "Eye and Vision Service Providers",
                 "160000000X" => "Nursing Service Providers",
                 "180000000X" => "Pharmacy Service Providers (Individuals)",
                 "200000000X" => "Allopathic & Osteopathic Physicians",
                 "210000000X" => "Podiatric Medicine and Surgery Providers",
                 "220000000X" => "Respiratory, Rehabilitative and Restorative Service Providers",
                 "230000000X" => "Speech, Language and Hearing Providers",
                 "250000000X" => "Agencies",
                 "260000000X" => "Ambulatory Health Care Facilities",
                 "280000000X" => "Hospitals",
                 "290000000X" => "Laboratories",
                 "300000000X" => "Managed Care Organizations",
                 "310000000X" => "Nursing and Custodial Care Facilities",
                 "320000000X" => "Residential Treatment Facilities",
                 "330000000X" => "Suppliers (including Pharmacies and Durable Medical Equipment)",
                 "360000000X" => "Physician Assistants and Advanced Practice Nursing Providers"}
  
  # alias :full_name :name

  def full_name
    [family_name, given_name].compact.join(", ")
  end
  
  def specialty_name
    Specialties[specialty]
  end
  
  def merge_eligible
    Provider.can_merge_with(self).alphabetical
  end
  
  def to_json(options={})
    super(options)
  end
  
  
  def self.merge_or_build(attributes)
    if attributes[:npi]
      provider = Provider.by_npi(attributes[:npi]).first
    end
    
    if provider
      provider.merge_provider(attributes)
    else
      provider = Provider.new(attributes)
    end
    
    provider
  end
  
	# added from bstrezze
  def self.generateUserProviderIDList(current_user)
    results = Array.new
    
    Provider.userfilter(current_user).each do |currentProvider|
      results << currentProvider._id      
    end
    
    return results
  end
  
  def merge_provider(provider)
    return false if !self.npi.blank? && !provider[:npi].blank? #cannot merge providers with different NPIs
    self.attributes = provider.attributes.merge(attributes.reject { |k,v| v.blank? })
    provider.records.each { |record| self.records << record  }
    true
  end
  
  def merge_provider!(provider)
    merge_provider(provider)
    save!
  end

end
