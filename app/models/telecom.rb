# Encapsulates the telecom section of a C32. Instead of having
# a bunch of telecom instances as part of a has_many, we've
# rolled the common ones into a single record. This should
# make validation easier when dealing with phone numbers
# vs. email addresses
class Telecom < ActiveRecord::Base

  strip_attributes!

  # AG: did you expect telecomable? ;-)
  # RM: yes... yes I did...
  belongs_to :reachable, :polymorphic => true

  after_save { |r| r.reachable.try(:patient).try(:update_attributes, :updated_at => DateTime.now) }

  def blank?
    %w[ home_phone work_phone mobile_phone
        vacation_home_phone email url ].all? {|a| read_attribute(a).blank? }
  end

  def requirements
    case reachable_type
      when 'Provider', 'Support', 'InsuranceProviderPatient', 'AdvanceDirective', 'Encounter': 
        {
          :home_phone => :hitsp_r2_optional,
          :work_phone => :hitsp_r2_optional,
          :mobile_phone => :hitsp_r2_optional,
          :vacation_home_phone => :hitsp_r2_optional,
          :email => :hitsp_r2_optional,
          :url => :hitsp_r2_optional,
        }
    end
  end

 

  def to_c32(xml= XML::Builder.new)
    if home_phone && home_phone.size > 0
      xml.telecom("use" => "HP", "value" => 'tel:' + home_phone)
    end
    if work_phone && work_phone.size > 0
     xml.telecom("use" => "WP", "value" => 'tel:' + work_phone)
    end
    if mobile_phone && mobile_phone.size > 0
      xml.telecom("use" => "MC", "value" => 'tel:' + mobile_phone)
    end
    if vacation_home_phone && vacation_home_phone.size > 0
      xml.telecom("use" => "HV", "value" => 'tel:' + vacation_home_phone)
    end
    if email && email.size > 0
      xml.telecom("value" => "mailto:" + email)
    end
    if url && url.size > 0
      xml.telecom("value" => url)
    end
  end

  def randomize()
    self.home_phone = format_number() 
    self.work_phone = format_number()
    self.mobile_phone = format_number()
  end

  def format_number()
    @number = Faker::PhoneNumber.phone_number
    @number = @number.gsub /\./, "-"
    @number = @number.gsub /\)/, "-"
    @number = @number.gsub /\(/, "1-"
    @number = @number.gsub /\ x.*/, ""
    if (@number.split("-")[0] == "1")
      @number = "+" + @number
    else
      @number = "+1-" + @number
    end
  end

end
