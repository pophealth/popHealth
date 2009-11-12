module ProviderRoleC32Validation

   include MatchHelper

   def validate_c32(role)
       unless role
           return [ContentError.new(:section => 'Provider', :subsection => 'ProviderRole',
                                    :error_message => 'Unable to find provider role')]
       end

       errors = []
       errors << match_value(role,'@code','code',code)
       errors << match_value(role,'@displayName','displayName',name)
       return errors.compact
   end

   #Reimplementing from MatchHelper
   def section_name
     'Provider'
   end

   #Reimplementing from MatchHelper  
   def subsection_name
     'ProviderRole'
   end


end