class Thorax.Models.Patient extends Thorax.Model
  urlRoot: '/api/patients'
  idAttribute: '_id'
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    attrs.birthdate = attrs.birthdate * 1000
    attrs.effective_time = attrs.effective_time * 1000
    attrs.entries = new Thorax.Collections.Entries
    for type in Thorax.Collections.Entries::types
      if attrs[type]?
        for entry in attrs[type] 
          attrs.entries.add entry, type: type
    attrs

class Thorax.Collections.Entries extends Thorax.Collection
  types: ['allergies', 'conditions', 'encounters', 'immunizations', 
      'medical_equipment', 'results', 'medications', 'procedures', 
      'vital_signs']
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
  comparator: (e) ->  -1 * e.get('start_time')

# Entry Models
# All have start time, end time, and description that should also
# be displayed

class Thorax.Models.Allergy extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'allergy'
  icon: -> 'stethoscope'

class Thorax.Models.Condition extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'condition'
  icon: -> 'stethoscope'
  
class Thorax.Models.Encounter extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'encounter'
  icon: -> 'user-md'

class Thorax.Models.Immunization extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'immunization'
  icon: -> 'medkit'

class Thorax.Models.MedicalEquipment extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'medical equipment'
  icon: -> 'medkit'

class Thorax.Models.Result extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'result'
  icon: -> 'flask'

class Thorax.Models.Medication extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'medication'
  icon: -> 'medkit'

class Thorax.Models.Procedure extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'procedure'
  icon: -> 'scissors'

class Thorax.Models.VitalSign extends Thorax.Model
  parse: (attrs) ->
    attrs.start_time = attrs.start_time * 1000
    attrs.end_time = attrs.end_time * 1000
    attrs
  entryType: -> 'result'
  icon: -> 'flask'