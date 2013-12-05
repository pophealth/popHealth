class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  context: ->
    _(super).extend
      effective_time: format_time @model.get('effective_time')
      birthdate: format_time @model.get('birthdate')
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
      # events: @model.get_events()

  # Helper function for date/time conversion
  format_time = (time) -> moment(time).format('DD MMM YYYY') if time

class Thorax.Views.EntryView extends Thorax.View
  context: ->
    _(super).extend
      start_time: format_time @model.get('start_time')
      end_time: '- ' + format_time @model.get('end_time') if @model.get('end_time')?
      entry_type: @model.entryType()
      
  # Helper function for date/time conversion
  format_time = (time) -> moment(time).format('MM-DD-YYYY') if time