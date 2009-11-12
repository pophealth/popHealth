module EncounterLocationCodeC32Validation

  include MatchHelper

  def validate_c32(encounter_location_code)

    unless encounter_location_code
      return [ContentError.new]
    end

    errors = []
    return errors.compact
  end

end