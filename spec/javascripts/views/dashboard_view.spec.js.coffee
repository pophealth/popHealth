describe 'Results View', ->
  beforeEach ->
    json = loadJSONFixtures 'query.json', 'queries/patient_results.json', 'users.json'
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    @providerId = json['queries/patient_results.json'][0].value.provider_performances[0].provider_id
    model = new Thorax.Models.Query $.extend(true, {}, json['query.json']), {parent: null}
    @measure_id = model.get('measure_id')
    @resultsViewWithProvider = new Thorax.Views.ResultsView model: model, id: @measure_id, provider_id: @providerId
    @resultsViewWithProvider.render()

  it 'links to the proper patient result view on provider', ->
    expect(@resultsViewWithProvider.$el.find('a')).toHaveAttr 'href', "#measures/#{@measure_id}/providers/#{@providerId}/patient_results"
