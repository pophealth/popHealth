# Initial cut at separating the C32 validation routines form the models.  All this currently does is to reinject the 
# models with the validation classes. The C32Validator then just calls the validate 32 method on the pateint data object

# FIXME Requiring files using the full path is bad practice.
# Ideally we should rename/namespace the *C32Validation modules so that they
# can be autoloaded by Rails.
Dir.glob(File.join(File.dirname(__FILE__), 'c32/*.rb')).each {|f| require f }

module Validators
  
   module C32Validation
       C32VALIDATOR = "C32Validator"
 
        def self.add_validation_routines()
          
           ActStatusCode.send :include,ActStatusCodeC32Validation
           Address.send :include,AddressC32Validation
           AdvanceDirective.send :include,AdvanceDirectiveC32Validation
           AdvanceDirectiveStatusCode.send :include,AdvanceDirectiveStatusCodeC32Validation
           AdvanceDirectiveType.send :include,AdvanceDirectiveTypeC32Validation
           Allergy.send :include,AllergyC32Validation
           AllergyStatusCode.send :include,AllergyStatusCodeC32Validation
           AllergyTypeCode.send :include,AllergyTypeCodeC32Validation
           Comment.send :include,CommentC32Validation
           Condition.send :include,ConditionC32Validation
           Encounter.send :include,EncounterC32Validation
           EncounterLocationCode.send :include,EncounterLocationCodeC32Validation
           EncounterType.send :include,EncounterTypeC32Validation
           Immunization.send :include,ImmunizationC32Validation
           InformationSource.send :include,InformationSourceC32Validation
           InsuranceProvider.send :include,InsuranceProviderC32Validation
           InsuranceProviderGuarantor.send :include,InsuranceProviderGuarantorC32Validation
           InsuranceProviderPatient.send :include,InsuranceProviderPatientC32Validation
           InsuranceProviderSubscriber.send :include,InsuranceProviderSubscriberC32Validation
           InsuranceType.send :include,InsuranceTypeC32Validation
           Language.send :include,LanguageC32Validation
           MedicalEquipment.send :include,MedicalEquipmentC32Validation
           Medication.send :include,MedicationC32Validation
           Patient.send :include,PatientDataC32Validation
           PersonName.send :include,PersonNameC32Validation
           ProblemType.send :include,ProblemTypeC32Validation
           Procedure.send :include,ProcedureC32Validation
           Provider.send :include,ProviderC32Validation
           ProviderRole.send :include,ProviderRoleC32Validation
           ProviderType.send :include,ProviderTypeC32Validation
           RegistrationInformation.send :include,RegistrationInformationC32Validation
           Result.send :include,ResultC32Validation
           ResultTypeCode.send :include,ResultTypeCodeC32Validation
           SeverityTerm.send :include,SeverityTermC32Validation
           Support.send :include,SupportC32Validation
           Telecom.send :include,TelecomC32Validation
           Vaccine.send :include,VaccineC32Validation
           
        end

      class Validator < Validation::BaseValidator
        
        

          def validate(patient,document)
            unless patient.respond_to? "validate_c32"
              C32Validation.add_validation_routines
            end
            
            errors = patient.validate_c32(document)
            # set the validator field for the errors
             errors.each do |e|
                e.validator = C32VALIDATOR
                e.inspection_type = ::CONTENT_INSPECTION
              end
            return errors
          end

       end

   end

end

# load it up to begin with
Validators::C32Validation.add_validation_routines
