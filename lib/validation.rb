module Validation
   
   def Validation.unregister_validators
     ValidationRegistry.instance.unregister_validators
   end
   
   def Validation.register_validator(doc_type, validator)
     ValidationRegistry.instance.register_validator(doc_type, validator)
   end
   
   def Validation.get_validator(type)
     ValidationRegistry.instance.get_validator(type)
   end
   
   def Validation.validate(patient_data, document)
     get_validator(document.doc_type).validate(patient_data,document)
   end

   class InvalidValidatorException < Exception
   end
   
   # this is just a stubbed out marker class to we can ensure that
   # everything that is registered as a validator really is one
   class BaseValidator
     
     
     
     def validate(patient_data, document)
         raise "Implement me damn it"
     end
     
   end
   
  class Validator
   
    attr_accessor :validators
    @validators = []
    @doc_type
    
    def initialize(doc_type)
      @validators = []
      @doc_type= doc_type
    end
    
    def validate(patient_data, document)
      errors = []       
      validators.each do |validator|
        errors.concat(validator.validate(patient_data,document))
      end

      errors
    end
    
    
    def << (validator)

         raise InvalidValidatorException if !validator.kind_of? Validation::BaseValidator
         validators << validator
    end
    
    def contains?(validator)
      validators.include?(validator)
    end
    
    def contains_kind_of?(validator)
      validators.any? {|v| v.kind_of?(validator)}
    end
  end 
  
  class ValidationRegistry
    include Singleton
    attr_accessor :validators

    def initialize()
       @validators={}
    end

    def unregister_validators
      initialize
    end

    def register_validator(doc_type, validator)
        
        raise InvalidValidatorException if !validator.kind_of? Validation::BaseValidator
        
        doc_validator = get_validator(doc_type)
        doc_validator << validator unless doc_validator.contains?(validator)
    end


    def get_validator(type)
      # just to make sure everything is normalized to capitalized symbols
      doc_type = type.class == Symbol ? type.to_s.upcase.to_sym : type.upcase.to_sym
      validator = @validators[doc_type]
      unless validator
        validator = Validator.new(type)
        @validators[doc_type] = validator
      end
      validator
    end

  end
end




