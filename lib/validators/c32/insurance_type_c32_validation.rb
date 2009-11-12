module InsuranceTypeC32Validation

  include MatchHelper

  def validate_c32(insurance_type_code)

    unless insurance_type_code
      return [ContentError.new]
    end

    errors = []
    errors << match_value(insurance_type_code,'@code','code',code)
    errors << match_value(insurance_type_code,'@displayName','displayName',name)

    return errors.compact
  end 

end