class Thorax.Models.Patient extends Thorax.Model
  urlRoot: '/api/patients'
  idAttribute: '_id'
  fetch: (options = {}) ->
    options.data ?= {}
    options.data.include_results = true
    super options
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    attrs.birthdate = attrs.birthdate * 1000
    attrs.effective_time = attrs.effective_time * 1000
    attrs.entries = new Thorax.Collections.Entries
    for type in Thorax.Collections.Entries::types
      if attrs[type]?
        for entry in attrs[type]
          attrs.entries.add entry, type: type
    if attrs.measure_results
      attrs.measure_results = new Thorax.Collections.PatientMeasureResults attrs.measure_results, parse: true, parent: this
    attrs

class Thorax.Collections.Entries extends Thorax.Collection
  types: ['allergies', 'conditions', 'encounters', 'immunizations',
      'medical_equipment', 'results', 'medications', 'procedures',
      'vital_signs']
  model: (attrs, options) ->
    klass =
      allergies:          Thorax.Models.Allergy
      conditions:         Thorax.Models.Condition
      encounters:         Thorax.Models.Encounter
      immunizations:      Thorax.Models.Immunization
      medical_equipment:  Thorax.Models.MedicalEquipment
      results:            Thorax.Models.Result
      medications:        Thorax.Models.Medication
      procedures:         Thorax.Models.Procedure
      vital_signs:        Thorax.Models.VitalSign
    new klass[options.type] attrs, parse: true

  comparator: (e) ->  -e.get('start_time')

# Entry Models
# All have start time, end time, and description that should also
# be displayed
class Thorax.Models.Entry extends Thorax.Model
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    attrs.start_time *= 1000
    attrs.end_time *= 1000
    if attrs.values
      attrs.values = new Thorax.Collection attrs.values
    attrs

class Thorax.Models.Allergy extends Thorax.Models.Entry
  entryType: 'allergy'
  icon: 'stethoscope'

class Thorax.Models.Condition extends Thorax.Models.Entry
  entryType: 'condition'
  icon: 'stethoscope'

class Thorax.Models.Encounter extends Thorax.Models.Entry
  entryType: 'encounter'
  icon: 'user-md'

class Thorax.Models.Immunization extends Thorax.Models.Entry
  entryType: 'immunization'
  icon: 'medkit'

class Thorax.Models.MedicalEquipment extends Thorax.Models.Entry
  entryType: 'medical equipment'
  icon: 'medkit'

class Thorax.Models.Result extends Thorax.Models.Entry
  entryType: 'result'
  icon: 'flask'

class Thorax.Models.Medication extends Thorax.Models.Entry
  entryType: 'medication'
  icon: 'medkit'

class Thorax.Models.Procedure extends Thorax.Models.Entry
  entryType: 'procedure'
  icon: 'scissors'

class Thorax.Models.VitalSign extends Thorax.Models.Entry
  entryType: 'result'
  icon: 'flask'
