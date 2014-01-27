class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  context: ->
    _(super).extend
      first: PopHealth.Helpers.maskName @model.get('first')
      last: PopHealth.Helpers.maskName @model.get('last')
      effective_time: formatTime @model.get('effective_time'), 'DD MMM YYYY'
      birthdate: formatTime @model.get('birthdate'), PopHealth.Helpers.maskDateFormat 'DD MMM YYYY'
      gender: if @model.get('gender') is 'M' then 'Male' else 'Female'
      race: if @model.has('race') then @model.get('race').name else 'None Provided'
      ethnicity: if @model.has('ethnicity') then @model.get('ethnicity').name else 'None Provided'
      languages: if _.isEmpty(@model.get('languages')) then 'Not Available' else @model.get('languages')
      measures: @measures()

  measures: ->
    measures = new Thorax.Collection
    if @model.has 'measure_results'
      resultsByMeasure = @model.get('measure_results').groupBy 'measure_id'
      for id, results of resultsByMeasure
        measure = new Thorax.Model id: id, title: results[0].get('measure_title')
        if results.length > 1
          measure.set submeasures: new Thorax.Collection({id: result.get('sub_id'), subtitle: result.get('measure_subtitle')} for result in results)
        measures.add measure
    return measures

  # measures: ->
  #   measures = new Thorax.Collection
  #   if @model.has 'measure_results'
  #     resultsByMeasure = @model.get('measure_results').groupBy (r) -> "#{r.get('measure_id')}/#{r.get('sub_id')}"
  #     for measureID, results of resultsByMeasure
  #       result = results[0] #
  #       measures.add id: measureID, sub_id: title: results[0].measure_title, subtitle:

  # Helper function for date/time conversion
  formatTime = (time, format) -> moment(time).format(format) if time

class Thorax.Views.EntryView extends Thorax.View
  context: ->
    _(super).extend
      start_time: formatTime @model.get('start_time')
      end_time: formatTime @model.get('end_time') if @model.get('end_time')?
      entry_type: @model.entryType
      icon: @model.icon
      description: @model.get('description')?.split('(')[0]

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
