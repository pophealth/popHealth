#
# This is the central record representing patient data.
#
class Patient < ActiveRecord::Base
  has_many_c32 :languages
  has_many_c32 :providers
  has_many_c32 :medications
  has_many_c32 :allergies
  has_many_c32 :insurance_providers
  has_many_c32 :conditions
  has_many_c32 :vital_signs
  has_many_c32 :results
  has_many_c32 :immunizations
  has_many_c32 :encounters
  has_many_c32 :procedures
  has_many_c32 :medical_equipments
  has_many_c32 :social_history
  has_many_c32 :patient_identifiers

  has_one_c32 :registration_information
  has_one_c32 :support
  has_one_c32 :information_source
  has_one_c32 :advance_directive

  # This is the aggregate of results and vital_signs, we don't destroy
  # dependent because results and vital_signs already do that.
  has_many :all_results, :class_name => 'AbstractResult'

  named_scope :templates, :conditions => { :test_plan_id => nil, :user_id => nil }
  named_scope :owned_by, lambda { |user|
    { :conditions => { :test_plan_id => nil, :user_id => user.id } }
  }

  def editable_by? owner
    user == owner
  end

  # these are used in the insurance_provider_* controllers
  def insurance_provider_guarantors
    InsuranceProviderGuarantor.by_patient(self)
  end
  def insurance_provider_patients
    InsuranceProviderPatient.by_patient(self)
  end
  def insurance_provider_subscribers
    InsuranceProviderSubscriber.by_patient(self)
  end

  belongs_to :test_plan
  belongs_to :user

  validates_presence_of :name

  # Generate an OID using the time and the patient's ActiveRecord ID.
  #
  # @return [String] generated OID
  def generate_unique_id
    "1.3.6.1.4.1.21367.2009.5.14.#{id}.#{Time.now.to_i}"
  end

  def patient_identifier
    registration_information.try(:affinity_domain_identifier)
  end

  # Generate a hash containing source_patient_info for use in XDS metadata.
  #
  # @return [Hash] patient info
  def source_patient_info
    spi = {}
    spi[:name] = name
    spi[:gender] = registration_information.gender.code
    spi[:date_of_birth] = registration_information.date_of_birth.to_s(:brief)
    spi[:source_patient_identifier] = patient_identifier
    spi
  end
  
  # Create a deep copy of the given patient record.
  #
  # @return [Patient] cloned instance
  def clone
    copy = super
    transaction do
      copy.save!

      %w[
        registration_information support information_source advance_directive
      ].each do |assoc|
        copy.send("#{assoc}\=", send(assoc).clone) if send(assoc)
      end

      %w[
        patient_identifiers languages providers medications allergies conditions
        all_results immunizations encounters procedures medical_equipments social_history insurance_providers
      ].each do |assoc|
        send(assoc).each do |item|
          copy.send(assoc) << item.clone
        end
      end

    end
    copy
  end

  # Build a C32 XML document representing the patient.
  #
  # @return [Builder::XmlMarkup] C32 XML representation of patient data
  def to_c32(xml = nil)
    xml ||= Builder::XmlMarkup.new(:indent => 2)

    xml.ClinicalDocument("xsi:schemaLocation" => "urn:hl7-org:v3 http://xreg2.nist.gov:8080/hitspValidation/schema/cdar2c32/infrastructure/cda/C32_CDA.xsd",
                         "xmlns" => "urn:hl7-org:v3",
                         "xmlns:sdtc" => "urn:hl7-org:sdtc",
                         "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance") do
      xml.typeId("root" => "2.16.840.1.113883.1.3",
                 "extension" => "POCD_HD000040")
      xml.templateId("root" => "2.16.840.1.113883.3.27.1776",
                     "assigningAuthorityName" => "CDA/R2")
      xml.templateId("root" => "2.16.840.1.113883.10.20.1", 
                     "assigningAuthorityName" => "CCD")
      xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.1", 
                     "assigningAuthorityName" => "HITSP/C32")
      xml.id("root" => "2.16.840.1.113883.3.72", 
             "extension" => "Laika C32 Test", 
             "assigningAuthorityName" => "Laika: An Open Source EHR Testing Framework projectlaika.org")
      xml.code("code" => "34133-9", 
               "displayName" => "Summarization of patient data", 
               "codeSystem" => "2.16.840.1.113883.6.1", 
               "codeSystemName" => "LOINC")
      xml.title(name)

      if registration_information.try(:document_timestamp)
        xml.effectiveTime("value" => c32_timestamp(registration_information.document_timestamp))
      else
        xml.effectiveTime("value" => c32_timestamp(updated_at))
      end
      xml.confidentialityCode
      xml.languageCode("code" => "en-US")

      # Start Person (Registation) Information
      xml.recordTarget do
        xml.patientRole do
          registration_information.try(:to_c32, xml)
        end
      end
      # End Person (Registation) Information

      information_source.try(:to_c32, xml)

      xml.custodian do
        xml.assignedCustodian do
          xml.representedCustodianOrganization do
            xml.id
          end
        end
      end

      if support && support.contact_type && support.contact_type.code != "GUARD"
        support.to_c32(xml)
      end

      providers.to_c32(xml)

      # Start CCD/C32 Modules
      xml.component do
        xml.structuredBody do
          
          pregnancy_c32(xml)

          conditions.to_c32(xml)

          allergies.to_c32(xml)
          no_known_allergies_c32(xml)

          insurance_providers.to_c32(xml)

          medications.to_c32(xml)

          advance_directive.try(:to_c32, xml)

          vital_signs.to_c32(xml)

          results.to_c32(xml)

          immunizations.to_c32(xml)

          encounters.to_c32(xml)

          procedures.to_c32(xml)
          
          social_history.to_c32(xml)

          medical_equipments.to_c32(xml)         
          
        end
      end
      # END CCD/C32 Modules
    end
  end

  # Populate a patient record with random values. This does not generate
  # semantically valid C32 documents.
  def randomize()
    self.registration_information ||= RegistrationInformation.new

    registration_information.randomize(self)
    self.name = registration_information.full_name

    # if patient is female, 10% chance patient is pregnant
    age = Date.today.year - self.registration_information.date_of_birth.year
    if self.registration_information.gender.code == 'F' && age > 14
      random_pregnant = rand(10) 
      if random_pregnant > 8
        self.pregnant = true 
      else
        self.pregnant = false
      end
    else
      self.pregnant = nil
    end 

    #provider = Provider.new
    #provider.randomize(self.registration_information)
    #self.providers << provider

    #insurance = InsuranceProvider.new
    #insurance.randomize(self.registration_information)
    #self.insurance_providers << insurance

    #allergy = Allergy.new
    #allergy.randomize(self.registration_information.date_of_birth)
    #self.allergies << allergy

    condition = Condition.new
    if condition.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :diabetes)
      self.conditions << condition
    end
    
    condition = Condition.new
    if condition.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :hypertension)
      self.conditions << condition
    end
    
    condition = Condition.new
    if condition.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :ischemia)
      self.conditions << condition
    end
    
    condition = Condition.new
    if condition.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :lipoid)
      self.conditions << condition
    end
    
    condition = Condition.new
    if condition.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :smoking)
      self.conditions << condition
    end

    condition = Condition.new
    if condition.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :mammogram)
      self.conditions << condition
    end

    #language = Language.new
    #language.randomize()
    #self.languages << language

    #immunization = Immunization.new
    #immunization.randomize(self.registration_information.date_of_birth)
    #self.immunizations << immunization

    medication = Medication.new
    medication.randomize()
    self.medications << medication

    #self.support = Support.new
    #self.support.randomize(self.registration_information.date_of_birth)
    
    self.information_source = InformationSource.new
    self.information_source.randomize()

    #result = Result.new
    #result.randomize(self.registration_information.gender, self.registration_information.date_of_birth)
    #self.results << result

    result = Result.new
    result.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :cholesterol)
    self.results << result
    
    result = Result.new
    result.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :LDL_C, conditions)
    self.results << result
    
    result = Result.new
    result.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :colorectal_screening)
    self.results << result

    result = Result.new
    result.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :A1c, conditions)
    self.results << result

    vital_sign = VitalSign.new
    vital_sign.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :systolic)
    self.vital_signs << vital_sign
    
    vital_sign = VitalSign.new
    vital_sign.randomize(self.registration_information.gender, self.registration_information.date_of_birth, :diastolic)
    self.vital_signs << vital_sign

    #self.advance_directive = AdvanceDirective.new
    #self.advance_directive.randomize(self.registration_information.date_of_birth)

    #encounter = Encounter.new
    #encounter.randomize(self.registration_information.date_of_birth)
    #self.encounters << encounter

    #procedure = Procedure.new
    #procedure.randomize(self.registration_information.date_of_birth)
    #self.procedures << procedure

    #medical_equipment = MedicalEquipment.new
    #medical_equipment.randomize(self.registration_information.date_of_birth)
    #self.medical_equipments << medical_equipment

    #patient_identifier = PatientIdentifier.new
    #patient_identifier.randomize()
    #self.patient_identifiers << patient_identifier

    my_social_history = SocialHistory.new
    my_social_history.randomize(self.registration_information.date_of_birth, conditions)
    self.social_history << my_social_history

    self
  end
  
  #find the patient template from the XDS id
  #these lookup values are neither indexed nor guaranteed to be unique. XXX
  def self.find_by_patient_identifier( id )
  
    split_id = id.split('^^^')
    patient_id = PatientIdentifier.find( :first, 
        :conditions => {  :patient_identifier => split_id.first, 
                          :affinity_domain => split_id.second }
     ).try( :patient_id )
     
     Patient.find( patient_id ) unless patient_id.nil?
  end

 private

  def c32_timestamp(datetime)
    datetime.to_s(:brief_timestamp) + datetime.formatted_offset(false)
  end

  # If the patient is pregnant, this method will add the appropriate
  # C32 component to the provided XML::Builder object.
  def pregnancy_c32(xml)
    if pregnant
      xml.component do
        xml.section do
          xml.title "Results"
          xml.text "Patient is currently pregnant"
          xml.entry do
            xml.observation("classCode" => "OBS", "moodCode" => "EVN") do
              # why is code here you ask, because the schema states it needs to be 
              # event though the C32 doc does not include it, one more reason to just
              # hate the CDA/CCD/C32 specs
              xml.code("code" => "77386006",
                       "displayName" => "Patient currently pregnant",
                       "codeSystem" => "2.16.840.1.113883.6.96",
                       "codeSystemName" => "SNOMED CT")
              xml.value("xsi:type" => "CD",
                        "code" => "77386006",
                        "displayName" => "Patient currently pregnant",
                        "codeSystem" => "2.16.840.1.113883.6.96",
                        "codeSystemName" => "SNOMED CT")
            end
          end
        end
      end
    end
  end
  
  # If the "No known allergies" flag is marked, this will add the required CCD xml
  # to the provided XML::Builder object
  def no_known_allergies_c32(xml)
    if no_known_allergies
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.2", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "48765-2", 
                   "codeSystem" => "2.16.840.1.113883.6.1")
          xml.title "Allergies, Adverse Reactions, Alerts"
          xml.text "No known allergies"
          xml.entry do
            xml.act("classCode" => "ACT", "moodCode" => "EVN") do
              xml.templateId("root" => "2.16.840.1.113883.10.20.1.27")
              xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.6")
              xml.id("root" => "2C748172-7CC2-4902-8AF0-23A105C4401B")
              xml.code("nullFlavor"=>"NA")
              xml.entryRelationship("typeCode" => "SUBJ") do
                xml.observation("classCode" => "OBS", "moodCode" => "EVN") do
                  xml.templateId("root" => "2.16.840.1.113883.10.20.1.18")
                  xml.value("xsi:type" => "CD",
                             "code" => "160244002", 
                             "displayName" => "No known allergies", 
                             "codeSystem" => "2.16.840.1.113883.6.96", 
                             "codeSystemName" => "SNOMED CT")
                end
              end
            end
          end
        end
      end
    end
  end
  
end
