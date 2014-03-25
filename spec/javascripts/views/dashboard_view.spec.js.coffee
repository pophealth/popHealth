describe 'Results View', ->
  beforeEach ->
    @json = loadJSONFixtures 'query.json', 'queries/patient_results.json', 'users.json'
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, @json['users.json'][0])
    @providerId = @json['queries/patient_results.json'][0].value.provider_performances[0].provider_id
    model = new Thorax.Models.Query $.extend(true, {}, @json['query.json']), {parent: null}
    @resultsViewWithProvider = new Thorax.Views.ResultsView model: model, id: model.attributes.measure_id, provider_id: @providerId
    console.log(@resultsViewWithProvider.render())
    @resultsViewWithProvider.render();

  it 'links to the proper patient result view on provider', ->
    expect(@resultsViewWithProvider.$el.find('a')).toHaveAttr 'href', '#measures/40280381-3D61-56A7-013E-66BC02DA4DEE/providers/525d98f501fbdf993a000082/patient_results'
