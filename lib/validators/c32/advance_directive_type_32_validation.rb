

module AdvanceDirectiveTypeC32Validation

    include MatchHelper

    def validate_c32(type)
  
        unless type
            return [ContentError.new]
        end
  
        errors = []
        errors << match_value(type,'@code','code',code)
        errors << match_value(type,'@displayName','displayName',name)
        errors.compact
        
        
    end 


end
