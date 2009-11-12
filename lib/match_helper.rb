 # Module to be included into models who do matching against clinical documents
  # The match value function will pull the section and subsection names from
  # the methods section_name and subsection_name. By default, section_name
  # will return the underscore name of the class. Subsection will return nil.
  # To change this behavior, reimplement section_name or subsection_name in
  # the model class.
  module MatchHelper
    DEFAULT_NAMESPACES = {"cda"=>"urn:hl7-org:v3"}
    
    def self.included(base)
      base.class_eval do
        def match_value(an_element, xpath, field, value)
          error = XmlHelper.match_value(an_element, xpath, value)
          if error
            return ContentError.new(:section => section_name, :subsection => subsection_name, :field_name => field,
                                    :error_message => error,
                                    :location=>(an_element) ? an_element.xpath : nil)
          else
            return nil
          end
        end
  
  
        def safe_match(element,&block)
           if element
              begin
                 yield(element) 
                 return nil
              rescue
                  return ContentError.new(:section => section_name, 
                                          :error_message => 'Error during validation of the #{section_name} section: #{$!}',
                                          :type=>'error',
                                          :location => element.xpath)
              end
            
           else
               return ContentError.new(:section => section_name, 
                                       :error_message => 'Null value supplied for matching',
                                       :type=>'error',
                                       :location =>nil)             
           end
     
        end    
  
  
        def match_required(element,xpath,namespaces,xpath_variables,subsection,error_message,error_location=nil,&block)
          content = REXML::XPath.first(element,xpath,namespaces,xpath_variables )
          if content
          yield(content) if block_given?
          return nil
          else
              return ContentError.new(:section =>section_name, 
                                      :error_message => error_message,
                                      :type=>'error',
                                      :location => error_location)
          end
        end
 
        def content_required(content,subsection,error_message,error_location=nil,&block)
         
               if content
               yield(content) if block_given?
               return nil
               else
                   return ContentError.new(:section =>section_name, 
                                           :error_message => error_message,
                                           :type=>'error',
                                           :location => error_location)
               end
        end
  
         
       def section_name
          self.class.name
        end
  
        def subsection_name
          nil
        end
        
        
         def deref(code)
            if code
              ref = REXML::XPath.first(code,"cda:reference",MatchHelper::DEFAULT_NAMESPACES)
              if ref
                REXML::XPath.first(code.document,"//cda:content[@ID=$id]/text()",MatchHelper::DEFAULT_NAMESPACES,{"id"=>ref.attributes['value'].gsub("#",'')}) 
              else
                nil
              end
            end
         end
      end
    end
  end