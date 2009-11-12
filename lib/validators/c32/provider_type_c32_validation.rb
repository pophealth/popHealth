module ProviderTypeC32Validation

  include MatchHelper

  def validate_c32(type)
    unless type
      return [ContentError.new(:section => 'Provider', 
                               :subsection => 'ProviderType',
                               :error_message => 'Unable to find provider type')]
    end
    errors = []
    errors << match_value(type,'@code','code',code)
    errors << match_value(type,'@displayName','displayName',name)
    return errors.compact
  end


end