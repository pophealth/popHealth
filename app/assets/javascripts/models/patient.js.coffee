class Thorax.Models.Patient extends Thorax.Model
  urlRoot: '/api/patients'
  idAttribute: '_id'
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    attrs.entries = new Thorax.Collections.Entries
    attrs.entries.comparator = (e) ->  -1 * e.get('start_time')
    for type in ['allergies', 'conditions', 'encounters', 'immunizations', 
      'medical_equipment', 'results', 'medications', 'procedures', 'vital_signs']
      if attrs[type]?
        for entry in attrs[type] 
          attrs.entries.add entry, type: type
    attrs

class Thorax.Collections.Entries extends Thorax.Collection
  model: (attrs, options) ->
    switch options.type
      when 'allergies'
        new Thorax.Models.Allergy attrs, parse: true
      when 'conditions'
        new Thorax.Models.Condition attrs, parse: true
      when 'encounters'
        new Thorax.Models.Encounter attrs, parse: true
      when 'immunizations'
        new Thorax.Models.Immunization attrs, parse: true
       when 'medical_equipment'
        new Thorax.Models.MedicalEquipment attrs, parse: true
      when 'results'
        new Thorax.Models.Result attrs, parse: true
      when 'medications'
        new Thorax.Models.Medication attrs, parse: true
      when 'procedures'
        new Thorax.Models.Procedure attrs, parse: true
      when 'vital_signs'
        new Thorax.Models.VitalSign attrs, parse: true

# Entry Models
# All have start time, end time, and description that should also
# be displayed

class Thorax.Models.Allergy extends Thorax.Model
  entryType: -> 'allergy'
  icon: -> 'stethoscope'

class Thorax.Models.Condition extends Thorax.Model
  entryType: -> 'condition'
  icon: -> 'stethoscope'
  
class Thorax.Models.Encounter extends Thorax.Model
  entryType: -> 'encounter'
  icon: -> 'user-md'

class Thorax.Models.Immunization extends Thorax.Model
  entryType: -> 'immunization'
  icon: -> 'medkit'

class Thorax.Models.MedicalEquipment extends Thorax.Model
  entryType: -> 'medical equipment'
  icon: -> 'medkit'

class Thorax.Models.Result extends Thorax.Model
  entryType: -> 'result'
  icon: -> 'flask'

class Thorax.Models.Medication extends Thorax.Model
  entryType: -> 'medication'
  icon: -> 'medkit'

class Thorax.Models.Procedure extends Thorax.Model
  entryType: -> 'procedure'
  icon: -> 'scissors'

class Thorax.Models.VitalSign extends Thorax.Model
  entryType: -> 'result'
  icon: -> 'flask'