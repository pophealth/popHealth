class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  context: ->
    _(super).extend
      first: PopHealth.Helpers.maskName @model.get('first')
      last: PopHealth.Helpers.maskName @model.get('last')
      effective_time: formatTime @model.get('effective_time'), 'DD MMM YYYY'
      birthdate: formatTime @model.get('birthdate'), PopHealth.Helpers.maskDateFormat 'DD MMM YYYY'
      gender: 
        if @model.get('gender') == 'M'
          'Male' 
        else
          'Female'
      race:
        if @model.has('race')
          @model.get('race').name
        else
          'None Provided'
      ethnicity:
        if @model.has('ethnicity')
          @model.get('ethnicity').name
        else
          'None Provided'
      languages:
        if @model.has('languages')
          if _.isEmpty(@model.get('languages')) then 'Not Available' else @model.get('languages')
        else
          'Not Available'

  # Helper function for date/time conversion
  formatTime = (time, format) -> moment(time).format(format) if time

class Thorax.Views.EntryView extends Thorax.View
  template: JST['patients/_result']
  context: ->
    _(super).extend
      start_time: formatTime @model.get('start_time')
      end_time: formatTime @model.get('end_time') if @model.get('end_time')?
      entry_type: @model.entryType()
      icon: @model.icon()
      description: @model.get('description').split('(')[0] if @model.get('description')

  # Helper function for date/time conversion
  formatTime = (time) -> moment(time).format('M/DD/YYYY') if time

### Note ###
#
# If more detail needs to be added to the entries later,
# Handlebars' partial helper works for including another file.
# Problem is it doesn't take a property holding the url - it needs
# a string literal, so you have to do if this type, use this partial
#
# {{#if allergy}} {{> "patients/_allergy"}} {{/if}}
#
# Where allergy is a property in the context that is true or false based 
# based on the entryType. Each type with a partial would need their own property.
