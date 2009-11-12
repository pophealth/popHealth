module Validators
  module Schema
    class Validator < Validation::BaseValidator
      require 'java'
      import 'javax.xml.validation.SchemaFactory'
      import 'javax.xml.XMLConstants'
      import 'javax.xml.transform.stream.StreamSource'
      import 'javax.xml.parsers.DocumentBuilder'
      import 'javax.xml.parsers.DocumentBuilderFactory'
      import 'java.io.ByteArrayInputStream'
      
      
      attr_accessor :validator_name
      
      def initialize(name, schema_file)
        @validator_name = name
        set_schema(schema_file)
      end
      
      # Validate the document against the configured schema
      def validate(patient_data, document)
        errors = []
        begin 
          doc = @document_builder.parse(ByteArrayInputStream.new(java.lang.String.new(document.to_s).getBytes))
          source = javax.xml.transform.dom.DOMSource.new(doc)
          validator = @schema.newValidator();
          validator.validate(source);
       rescue 
          # this is where we will do something with the error
          
          errors << ContentError.new(:error_message=>$!.message, :validator=>@validator_name,:inspection_type=>::XML_VALIDATION_INSPECTION)
       end
       errors
      end
      
      
      private 
      # set the schema file and create the java objects to perfrom the validation
      def set_schema(file)
        factory = javax.xml.validation.SchemaFactory.newInstance(javax.xml.XMLConstants::W3C_XML_SCHEMA_NS_URI)
        schemaFile =  javax.xml.transform.stream.StreamSource.new(java.io.File.new(file));
        @schema = factory.newSchema(schemaFile)
        @document_builder_factory =  javax.xml.parsers.DocumentBuilderFactory.newInstance()
        @document_builder_factory.setNamespaceAware(true)
        @document_builder = @document_builder_factory.newDocumentBuilder()
      end

    end
  end
end
  
