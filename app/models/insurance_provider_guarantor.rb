class InsuranceProviderGuarantor < ActiveRecord::Base

  strip_attributes!

  include InsuranceProviderChild

  include PersonLike
  

  def to_c32(xml)

  end

  def randomize()
    self.person_name = PersonName.new
    self.address = Address.new
    self.telecom = Telecom.new

    self.person_name.first_name = Faker::Name.first_name
    self.person_name.last_name = Faker::Name.last_name
    self.address.randomize()
    self.telecom.randomize()
    self.effective_date =  DateTime.new(1950 + rand(58), rand(12) + 1, rand(28) + 1)
  end

end
