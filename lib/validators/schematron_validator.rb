module Validators
  module Schematron
    require 'java'
    import 'java.io.ByteArrayInputStream'
    import 'java.io.ByteArrayOutputStream'

    import "javax.xml.transform.Templates"
    import "javax.xml.transform.Transformer"
    import "javax.xml.transform.TransformerFactory"
    import "javax.xml.transform.stream.StreamSource"
    import "javax.xml.transform.stream.StreamResult"
    
    
    def self.create_source(str)
      StreamSource.new(ByteArrayInputStream.new(java.lang.String.new(str).getBytes()))
    end
    
    
    # base validator class, handles the acutal validation process as it's common between the compiled (XSLT pre computed) 
    # and the uncompiled (Do a transform of the schematron rules resulting in a stylesheet and use that stylesheet to do the validation)
    class BaseValidator < Validation::BaseValidator
      
   
      
      # validate the document, This performs the XSLT transform on the document and then looks for any errors in the 
      # resulting doc, errors show up as failed-assert elements in the result.
      def validate(patient_data,document)
           errors = []
           style = get_schematron_processor
           #yes actually need to convert to java.io.String to work
           source = Validators::Schematron.create_source(document.to_s)
           
           # process the document
           result = style.process(source)
           # create an REXML::Document form the results
           redoc = REXML::Document.new result
           # loop over failed assertions 
           redoc.elements.to_a("//svrl:failed-assert").each do |el|
            
             # do something here with the values
            errors << ContentError.new(:location => el.attributes["location"],
                                       :error_message => el.elements['svrl:text'].text,
                                       :validator => name,
                                       :inspection_type => ::XML_VALIDATION_INSPECTION)
           end
           errors
      end
        
        
        # stubbed method needed to obtain validation  stylesheet
      def get_schematron_processor
        raise "Implement me damn it"
      end
          
      
    end
    
    
    class UncompiledValidator < BaseValidator
      
      attr_accessor :schematron_file, :stylesheet, :cache, :name
      
      # create a new UnCompiledValidator
      # schematron_file - the base schematron rule set that will be used to create the XSLT stylesheet used to perform the validation
      # stylesheet - this is the stylesheet that will be used on the schematron rules to create the validation stylesheet
      # cache - whether or not to cache the validation stylesheet, if false (default) then it will compute the validation stylesheet each time validate is called
      def initialize(name,schematron_file, stylesheet, cache=false)
        @name = name
        @schematron_file  = schematron_file
        @stylesheet = stylesheet
        @cache = cache       
        @stylesheet_processor = XslProcessor.new_instance_from_file(stylesheet)      
      end

      
      # get the validation stylesheet returning either the cached instance or creating a new instance
      def get_schematron_processor
        
        return @schematron_processor if @schematron_processor
        
        baos = ByteArrayOutputStream.new
        res = StreamResult.new(baos)
        
        @stylesheet_processor.process(StreamSource.new(java.io.File.new(java.lang.String.new(schematron_file.to_s))),res)
        processor = XslProcessor.new_instance_from_string(java.lang.String.new(baos.toByteArray()).to_s)
        if cache
          @schematron_processor = processor
        end
        return processor
      end
      
    end
    
    # CompileValidator -  Validate based off pre-computed XSL stylesheet
    # 
    class CompiledValidator < BaseValidator
      
      attr_accessor :stylesheet, :name
      
      # stylesheet -  the precomputed validation stylesheet used to validate the document
      def initialize(name,stylesheet)
        @name = name
        @stylesheet = stylesheet
      end

      # return the cached xsl processor or create a new one and cache it in the instance variable
      def get_schematron_processor
        return @schematron_processor if @schematron_processor
        @schematron_processor =  XslProcessor.new_instance_from_file(stylesheet)        
      end
      
    end
    
    # Class used to perform the XSLT transformations
    class XslProcessor
      
      
      # Create a new instance from a file location
      # file - the xslt file , can be either a string location or a ruby File object
      def self.new_instance_from_file(file)
        
        source = StreamSource.new(java.io.File.new(file))
        data = ""
        if file.class == String
          File.open(file,"r") do |f|
           data =  f.read()
          end
          
        elsif file.class == File
         data = file.read()
        end
        
        new_instance_from_source(source)
        
      end
      
      # Create a new instance from a string representaion of the xtylesheet
      # xsd - a ruby string 
      def self.new_instance_from_string(xsd)
          new_instance_from_input_stream(ByteArrayInputStream.new(java.lang.String.new(xsd.to_s).getBytes()))
      end
      
      # create a new instance from the input_stream
      #input_stream - a java.io.InputStream 
      def self.new_instance_from_input_stream(input_stream)
         new_instance_from_source(StreamSource.new(input_stream))
      end
      
      
      # Create a new instance from the Source
      # souce - a javax.xml.transform.Source object
      def self.new_instance_from_source(source)
       self.new(source)
      end

      # perfrom the xslt transformation on the xml 
      # source -  javax.xml.transform.source object representing the xml to transform
      # result - javax.xml.transform.Result object where results will be placed, can be nil at which point a Result object will be created and the resulting string returned
      def process(source, result = nil)
        res = result 
       
        if source.class == String
         source =  Validators::Schematron.create_source(source)
        end
        
        unless res
           baos = ByteArrayOutputStream.new 
           # StreamResult based on byte output stream
           res = StreamResult.new(baos)
        end
          
        trans = @style_sheet.newTransformer()
        trans.transform(source,res)
          
        unless result
            return java.lang.String.new(baos.toByteArray).to_s 
        end
        
      end
      
      
      private 
      # create a new instance based on the source object
      def initialize(source)
         @transformer_factory = TransformerFactory.newInstance()
         @source = source
         @style_sheet = @transformer_factory.newTemplates(@source)  
      end
      

    end
    
  end
end
