module PatientsHelper
  def race(patient)
     if patient.race.kind_of? String
       return patient.race
     end

     r = Race.from_code(patient.race["code"]).first if patient.race
     r = r || {}
     r["name"] || ""
  end

  def ethnicity(patient)
    if patient.ethnicity.kind_of? String
      return patient.ethnicity
    end
    e = Ethnicity.from_code(patient.ethnicity["code"]).first if patient.ethnicity
    e = e || {}
    e["name"] || ""
  end
end