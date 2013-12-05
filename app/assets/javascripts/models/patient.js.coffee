class Thorax.Models.Patient extends Thorax.Model
  urlRoot: '/api/patients'
  idAttribute: '_id'
  parse: (attrs) ->
    attrs = $.extend {}, attrs
    attrs.entries = new Thorax.Collections.Entries
    attrs.entries.comparator = (e) ->  -1 * e.get('start_time')
    for type in ['allergies', 'conditions', 'encounters', 'immunizations', 
      'results', 'medications', 'procedures', 'vital_signs']
      if attrs[type]?
        for entry in attrs[type] 
          attrs.entries.add entry, type: type
    attrs

class Thorax.Collections.Entries extends Thorax.Collection
  model: (attrs, options) ->
    switch options.type
      when 'allergies'
        new Thorax.Models.Allergy attrs
      when 'conditions'
        new Thorax.Models.Condition attrs
      when 'encounters'
        new Thorax.Models.Encounter attrs
      when 'immunizations'
        new Thorax.Models.Immunization attrs
      when 'results'
        new Thorax.Models.Result attrs
      when 'medications'
        new Thorax.Models.Medication attrs
      when 'procedures'
        new Thorax.Models.Procedure attrs
      when 'vital_signs'
        new Thorax.Models.VitalSign attrs

# Entry Models
# All have start time, end time, and description that should also
# be displayed along with the listed fields

# TODO - How do I display Hash values?
# TODO - Does each type need a separate template? Would that avoid the 
# the need for the 'displayFields' property?

class Thorax.Models.Allergy extends Thorax.Model
  entryType: -> 'allergy'
  displayFields: -> ['type', 'reaction', 'severity'] 

class Thorax.Models.Condition extends Thorax.Model
  entryType: -> 'condition'
  displayFields: -> ['type', 'causeOfDeath', 'time_of_death', 'name']
  
class Thorax.Models.Encounter extends Thorax.Model
  entryType: -> 'encounter'
  displayFields: -> ['admitType', 'reason']

class Thorax.Models.Immunization extends Thorax.Model
  entryType: -> 'immunization'
  displayFields: -> ['seriesNumber', 'medication_product']

class Thorax.Models.Result extends Thorax.Model
  entryType: -> 'result'
  displayFields: -> ['type', 'interpretation']

class Thorax.Models.Medication extends Thorax.Model
  entryType: -> 'medication'
  displayFields: -> ['dose', 'typeOfMedication', 'statusOfMedication']

class Thorax.Models.Procedure extends Thorax.Model
  entryType: -> 'procedure'
  displayFields: -> ['site']

class Thorax.Models.VitalSign extends Thorax.Model
  entryType: -> 'lab_result'
  displayFields: -> ['type', 'interpretation']