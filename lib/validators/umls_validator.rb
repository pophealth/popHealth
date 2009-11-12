module Validators
   module Umls
    #Base class that sets the connection information for all of the other  UMLS models to use
    class UmlsBase < ActiveRecord::Base
        self.abstract_class = true
        # if the db is not configured it will break the build while loading the files
        # this is a complete hack so the build will not break when umls is not configured or 
        # being tested
        if ActiveRecord::Base.configurations["umls_#{RAILS_ENV}" ]
           establish_connection("umls_#{RAILS_ENV}")     
        end    
    end
    
    class UmlsCodeHierarchy < UmlsBase
        set_table_name "MRHIER"
    end
    
    class UmlsCodeSystem < UmlsBase
        set_table_name :MRSAB
        set_primary_key :VSAB


        def get_children
           UmlsConcept.find(:all, :conditions=>["sab = ? ",self.RSAB ],:order=>"aui") 
        end
    end

    class UmlsConcept < UmlsBase
      set_table_name :MRCONSO
      set_primary_key :AUI

       def get_children
        concepts = []
        UmlsCodeHierarchy.find(:all, :conditions=>["AUI=?",self.AUI]).each do |hier|
            concepts << UmlsConcept.find_by_sql("Select * from MRCONSO conso,(select aui from MRHIER where PTR like '#{hier.PTR}.#{self.AUI}.%') hier where hier.AUI=conso.AUI ")
        end
        concepts
      end

      def hierarchy_entries
          UmlsCodeHierarchy.find(:all, :conditions=>["AUI=?",self.AUI])
      end
    end

    # Class that validates documents against codes and codesystems in the UMLS database
    class UmlsValidator < Validation::BaseValidator
        # The mapping file maps the oid's that would be found in a clinical document to the logical codesystem 
        # identifier in the UMLS db
        UMLS_MAPPING_DEFAULT = "config/UMLS_MAPPING_FILE.yaml"
        
        attr_accessor :mapping, :msg_type
        

        def initialize(m_type)
         @mapping = YAML.load_file(UMLS_MAPPING_DEFAULT)    
         @msg_type=m_type
        end   


        # Validate a given xml document against the umls db. This validation only looks to see 
        # if the code 
        def validate(pateint_data,document)
       
         errors = []
         
         # get every element with a code system attribute - if REXML supported XPath correctly 
         # we could get every element with a code and codeSystem attribute like so 
         #     document.elements.to_a("//*[@codeSystem and @code]")
         #
         # but REXML doesnt return anything for that , evn though it should, Anyway, for every 
         # element with a codeSystem and code attribute we look to see if the code is in the code system according to 
         # the UMLS database.  
         document.elements.to_a("//*[@codeSystem]").each do |el|
           oid = el.attributes["codeSystem"]
           code = el.attributes["code"] 
           name = el.attributes["name"]
           map = @mapping[oid]        

           # figure out how to handle the errors here
            unless validate_code(oid,code,name)
               errors << ContentError.new(:location=>el.xpath,
                                          :error_message=>"Code #{code} not found in CodeSystem #{oid}",
                                          :validator=>"UmlsValidator",
                                          "msg_type"=>msg_type,
                                          :inspection_type=>::UMLS_CODESYSTEM_INSPECTION)
            end          
                 
         end   
         errors     
        end

        # validate whether the code with the given name, if present, exists in the code system mapped to the oid
        def validate_code(oid,code,name=nil)
          valid = true  
          map = @mapping[oid]   
          
          # if there isnt a mapping for leave it alone , we know nothing about the code system and cannot pass judgment 
          # on whether or not it's valid.   
          if map && code 
              cs = map["codesystem"]
              parent = map["umlscode"]
              valid = parent ? in_code_system_with_parent(cs,parent,code,name)  :  in_code_system(cs,code,name)
            end
         valid
        end
        

    private 
         # look for an entry in the UMLS db that corrisponds to the maping, if there is one, in the mapping table
         # if the mapping exists check UMLS to see if it is present.
         def get_code_system(oid)
            code_system = @mapping[oid]
            if(code_system.nil?)
            else
            sab = code_system["codesystem"]
            # potential umls parent code-  this is very prevelent in the HL7 
            # code system where the code system for all of it's entries is HL7V3.0 or similar
            # but there is a hierarchy mapping that needs to be consulted to determin if the code 
            # exists in the 'oid' code system
            concept = code_system["umlscode"]
            if concept.nil?    
              return UmlsCodeSystem.find_by_RSAB(sab)
            else
              return UmlsConcept.find_by_SAB_and_CODE(sab,concept) 
            end
            end
        end
        
       # if there wasnt a umlscode in the mapping file for the oid in question we do a straight lookup based on
       # code_system and code and possibly an optional name
        def in_code_system( code_system,  code,  name = nil)
             params = {:sab=>code_system, :code=>code}
             params[:str ] = name if name            
             UmlsConcept.count(:conditions=>params) > 0 
        end
        
        
        # If there was a umlscode in the mapping file for the oid then we need to consult the UMLS hierarchy to see
        # if the given code is in the hierarchy of the parent_code (umlscode).  To do this we obtain all of the concept
        # entries for the parent_code in the given code_system , there may be more then one.   Then we look in the hierarchy
        # for all of those entries.   For each hierarchy entry we look to see if the list of potential child codes ( yes there may be more then one entry)
        # exist in the hierarchy under the parent code.  The hierarchy is determined by a concatination of the concept AUI field entries separated by
        # '.' .  We use simple LIKE expressions to see of the hierarchy may contain any of the children
        def in_code_system_with_parent( code_system,  parent_code,  code, name = nil)
            params = {:sab=>code_system, :code=>code}
            params[:str ] = name if name
            parent_auis = UmlsConcept.find(:all,:conditions=>["sab = ? and code = ?",code_system,parent_code]).collect{|x| x.AUI }
            child_auis =  UmlsConcept.find(:all,:conditions=>params).collect{|x| x.AUI }

            UmlsCodeHierarchy.find(:all,:conditions=>["aui in (?)", parent_auis]) .each do |hier|
                like = "#{hier.PTR}.#{hier.AUI}"
                count = UmlsCodeHierarchy.count(:conditions=>["(ptr LIKE ? or ptr LIKE ?) and aui in (?)",like,"#{like}.%", child_auis])
                if count > 0 
                   return true
                end
            end
            return false
        end
    end

   end
  
end



