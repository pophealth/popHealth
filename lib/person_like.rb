module PersonLike

  def self.included(base)
    base.class_eval do
      has_one :person_name, :as => :nameable, :dependent => :destroy
      has_one :address, :as => :addressable, :dependent => :destroy
      has_one :telecom, :as => :reachable, :dependent => :destroy
      #accepts_nested_attributes_for :person_name, :address, :telecom
      include PersonLikeInstance
    end
  end

  module PersonLikeInstance
    def initialize(*args)
      super
      build_person_name unless person_name
      build_address     unless address
      build_telecom     unless telecom
    end

    def clone
      copy = super
      copy.save!
      copy.person_name = person_name.clone if person_name
      copy.address     = address.clone     if address
      copy.telecom     = telecom.clone     if telecom
      copy
    end

    def person_blank?
      %w[ person_name address telecom ].all? {|a| read_attribute(a).blank? }
    end

    def full_name
      "#{person_name.first_name} #{person_name.last_name}"
    end
  end

end
