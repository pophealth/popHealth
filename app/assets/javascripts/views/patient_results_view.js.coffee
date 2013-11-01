class Thorax.Views.PatientResultsView extends Thorax.View
  template: JST['patient_results/index']
  initialize: ->
    @query.on 'change', => 
      @setCollection(@query.get('patient_results'), {render: true})
      @query.get('patient_results').fetch()
    if @query.isNew()
      @query.fetch() 
    else 
      @setCollection(@query.get('patient_results'))
      @query.get('patient_results').fetch()

    
