class InsuranceProvider < ActiveRecord::Base

  strip_attributes!

  belongs_to :insurance_type
  belongs_to :coverage_role_type
  belongs_to :role_class_relationship_formal_type

  has_one :insurance_provider_patient,    :dependent => :destroy
  has_one :insurance_provider_subscriber, :dependent => :destroy
  has_one :insurance_provider_guarantor,  :dependent => :destroy

  include PatientChild
  include Commentable

  def requirements
    {
      :represented_organization => :required,
      :insurance_type_id => :hitsp_r2_optional,
      :coverage_role_type_id => :required,
      :role_class_relationship_formal_type_id => :required,
      :start_service => :hitsp_optional,
      :end_service => :hitsp_optional,
      :provider_type_id => :hitsp_r2_optional,
      :provider_role_id => :hitsp_r2_optional,
      :provider_role_free_text => :hitsp_r2_optional,
      :organization => :hitsp_r2_optional,
      :patient_identifier => :hitsp_r2_optional,
      :health_plan => :hitsp_r2_optional,
    }
  end

  def initialize(*args)
    super
    build_insurance_provider_patient    unless insurance_provider_patient
    build_insurance_provider_subscriber unless insurance_provider_subscriber
    build_insurance_provider_guarantor  unless insurance_provider_guarantor
  end

  def clone
    copy = super
    copy.insurance_provider_patient    = insurance_provider_patient.clone    if insurance_provider_patient
    copy.insurance_provider_subscriber = insurance_provider_subscriber.clone if insurance_provider_subscriber
    copy.insurance_provider_guarantor  = insurance_provider_guarantor.clone  if insurance_provider_guarantor
    copy
  end

  def to_c32(xml)
    xml.entry do
      xml.act("classCode" => "ACT", "moodCode" => "DEF") do
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.20", "assigningAuthorityName" => "CCD")
        xml.id("root" => group_number, "extension" => "GroupOrContract#")
        xml.code('code'=>'48768-6', 'displayName'=>'Payment Sources',
            'codeSystem'=>'2.16.840.1.113883.6.1' ,'codeSystemName'=>'LOINC')
        xml.statusCode('code'=>'completed')
        xml.entryRelationship("typeCode" => "COMP") do
          xml.act("classCode" => "ACT", "moodCode" => "EVN") do
            xml.templateId("root" => "2.16.840.1.113883.10.20.1.26")
            xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.5")
            xml.id("root" => group_number, "extension" => "GroupOrContract#")
            if insurance_type 
              xml.code("code" => insurance_type.code, 
                       "displayName" => insurance_type.name, 
                       "codeSystem" => "2.16.840.1.113883.6.255.1336", 
                       "codeSystemName" => "X12N-1336")
            else
              xml.code("nullFlavour"=>"NA")
            end
            xml.statusCode('code'=>'completed')

            # represented organization
            if represented_organization 
              xml.performer("typeCode" => "PRF") do
                xml.assignedEntity("classCode" => "ASSIGNED") do
                  xml.id('root'=>'2.16.840.1.113883.3.88.3.1')
                  xml.representedOrganization("classCode" => "ORG") do
                    xml.id("root" => "2.16.840.1.113883.19.5")
                    xml.name represented_organization
                  end
                end
              end
            end

            # guarantor is provided only if there is some non-nil, non-empty data
            if insurance_provider_guarantor && !insurance_provider_guarantor.person_blank?
              attrs = (represented_organization) ? {} : {"typeCode" => "PRF"}
              xml.performer(attrs) do
                if !insurance_provider_guarantor.effective_date.blank?
                  xml.time("value" => insurance_provider_guarantor.effective_date.to_s(:brief))
                end
                xml.assignedEntity do
                  xml.id
                  code_atts = {"code" => "PAYOR","codeSystem" => "2.16.840.1.113883.5.110"}
                  if insurance_type && insurance_type.code == 'PP'
                    if insurance_provider_guarantor
                      code_atts['code'] = "GUAR"
                    else
                      code_atts['code'] = "PAT"
                    end
                  end
                  xml.code(code_atts)
                  xml.assignedPerson do
                    insurance_provider_guarantor.person_name.to_c32(xml)
                  end
                end
              end
            end

            # patient data is provided only if there is some non-nil, non-empty data
            if insurance_provider_patient && !insurance_provider_patient.person_blank?
              xml.participant("typeCode" => "COV") do
                xml.participantRole("classCode" => "PAT") do
                  if coverage_role_type
                    xml.code("code" => coverage_role_type.code, 
                             "displayName" => coverage_role_type.name, 
                             "codeSystem" => "2.16.840.1.113883.5.111", 
                             "codeSystemName" => "RoleCode") 
                  end
                  xml.playingEntity do
                    insurance_provider_patient.person_name.try(:to_c32, xml)
                    if !insurance_provider_patient.date_of_birth.blank?
                      xml.sdtc(:birthTime, "value" => insurance_provider_patient.date_of_birth.to_s(:brief))
                    end
                  end
                end
              end
            end

            insurance_provider_subscriber.try(:to_c32, xml)
            
            # if health plan name is provided 
            if health_plan
              xml.entryRelationship("typeCode" => "REFR") do
                xml.act("classCode" => "ACT", "moodCode" => "DEF") do
                  xml.id("id" => "id", "extension" => "PlanCode")
                  xml.code("code" => "HMO", 
                           "displayName" => "health maintenance organization policy", 
                           "codeSystem" => "2.16.840.1.113883.5.4", 
                           "codeSystemName" => "ActCode")
                  xml.text health_plan
                end
              end
            end

          end
        end
      end
    end
  end
 
 
  def randomize(patient_info)
    self.insurance_provider_patient = InsuranceProviderPatient.new
    self.insurance_provider_patient.randomize(patient_info)

    self.insurance_provider_subscriber = InsuranceProviderSubscriber.new
    self.insurance_provider_subscriber.randomize()

    self.insurance_provider_guarantor = InsuranceProviderGuarantor.new
    self.insurance_provider_guarantor.randomize()

    self.role_class_relationship_formal_type = RoleClassRelationshipFormalType.find :random
    self.coverage_role_type = CoverageRoleType.find :random
    self.insurance_type = InsuranceType.find :random
    if (self.insurance_type_id != 606711552)
      self.group_number = nil
    else
      self.group_number = (100000000 + rand(8999999999)) #generates a random 9 digit group number
    end

    @organizations = ["Aetna", "Altius", "Anthem Blue Cross", "Health Net", "Medica", "Pacificare", "Unicare", "Lifewise", "CIGNIA", "Medical Mutual", "Harvard Pilgrim", "Humana", "MetLife"]
    self.represented_organization = @organizations[rand(@organizations.size)]

  end
 
  def self.c32_component(insurance_providers, xml)
    # Start Insurance Providers
    if insurance_providers.size > 0
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.9", 
                         "assigningAuthorityName" => "CCD")         
          xml.code("code" => "48768-6", 
                  "codeSystem" => "2.16.840.1.113883.6.1",
                   "codeSystemName" => "LOINC")
          xml.title "Insurance Providers"
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Insurance Provider Name"
                  xml.th "Insurance Provider Type"
                  xml.th "Insurance Provider Group Number"
                end
              end
              xml.tbody do
               insurance_providers.try(:each) do |insurance_provider|
                 xml.tr do
                    if insurance_provider.represented_organization != nil
                      xml.td insurance_provider.represented_organization
                    else
                      xml.td
                    end 
                    if insurance_provider.represented_organization != nil
                      xml.td insurance_provider.represented_organization
                    else
                      xml.td
                    end  
                    if insurance_provider.group_number != nil
                      xml.td insurance_provider.group_number
                    else
                      xml.td
                    end 
                  end
                end
              end
            end
          end

          # XML content inspection
          yield

        end
      end
    end
    # End Insurance Providers
  end
end
