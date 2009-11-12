require File.dirname(__FILE__) + '/../spec_helper'

C32_SCHEMA_VALIDATOR = Validators::Schema::Validator.new("C32 Schema Validator", "resources/schemas/infrastructure/cda/C32_CDA.xsd")
C32_SCHEMATRON_VALIDATOR = Validators::Schematron::CompiledValidator.new("C32 Schematron Validator","resources/schematron/c32_v2.1_errors.xslt")
CCD_SCHEMATRON_VALIDATOR = Validators::Schematron::CompiledValidator.new("CCD Schematron Validator","resources/schematron/ccd_errors.xslt")
C32_CONTENT_VALIDATOR = Validators::C32Validation::Validator.new
UMLS_VALIDATOR = Validators::Umls::UmlsValidator.new("warning")

describe Validation::Validator do

  before(:all) do
    Validation.unregister_validators
    Validation.register_validator :C32, C32_CONTENT_VALIDATOR
    Validation.register_validator :C32, C32_SCHEMA_VALIDATOR
    Validation.register_validator :C32, CCD_SCHEMATRON_VALIDATOR
    Validation.register_validator :C32, C32_SCHEMATRON_VALIDATOR
  end

  it "should be able to register validators" do 
    Validation.get_validator(:C32).should_not be_nil
    Validation.get_validator(:C32).validators.length.should == 4
  end
  
  it "should be able to tell if it contains a specific validator" do
    validator = Validation.get_validator(:C32)
    validator.contains?(C32_SCHEMATRON_VALIDATOR).should_not be_nil
    validator.contains?(UMLS_VALIDATOR).should be_false
  end
  
  it "should be able to tell if it contains a specific kind of validator" do
    validator = Validation.get_validator(:C32)
    validator.contains?(Validators::Schematron::CompiledValidator).should_not be_nil
    validator.contains?(Validators::Umls::UmlsValidator).should be_false
  end

  describe "with built-in records" do
  
    fixtures %w[
  act_status_codes addresses advance_directive_status_codes advance_directives
  advance_directive_types adverse_event_types allergies allergy_status_codes
  allergy_type_codes clinical_documents code_systems conditions contact_types
  coverage_role_types encounter_location_codes encounters encounter_types ethnicities
  genders immunizations information_sources insurance_provider_guarantors
  insurance_provider_patients insurance_provider_subscribers insurance_providers
  insurance_types iso_countries iso_languages iso_states language_ability_modes
  languages loinc_lab_codes marital_statuses medical_equipments medications
  medication_types no_immunization_reasons patients patient_identifiers person_names problem_types
  procedures provider_roles providers provider_types races registration_information
  relationships religions abstract_results result_type_codes role_class_relationship_formal_types
  severity_terms supports telecoms users vaccines vendors zip_codes
    ]



    [ :david_carter, :emily_jones, :jennifer_thompson, :theodore_smith, :joe_smith, :will_haynes ].each do |patient|
      it "should round-trip validate #{patient} without errors or warnings" do
        record = patients(patient)
        document = REXML::Document.new(record.to_c32)
        validator = Validation.get_validator(:c32)
        errors = validator.validate(record,document)        
        errors.should be_empty
      end
    end
  end
end
