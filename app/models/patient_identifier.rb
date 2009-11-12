class PatientIdentifier < ActiveRecord::Base

  strip_attributes!

  include PatientChild

  @@default_namespaces = {"cda"=>"urn:hl7-org:v3"}

  def requirements
    {
      :patient_identifier => :required,
      :affinity_domain => :required,
    }
  end

  def identifier_and_domain
    "#{patient_identifier}^^^#{affinity_domain}"
  end
  alias_method :to_s, :identifier_and_domain

  def randomize()
    self.patient_identifier = rand(10 ** 10).to_s.rjust(10,'0')
    self.affinity_domain = "CCHIT&1.2.3.4.5.6.7.8.9&ISO"
  end
end
