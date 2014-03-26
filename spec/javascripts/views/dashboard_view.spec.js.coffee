describe 'Dashboard', ->
  beforeEach ->
    json = loadJSONFixtures 'categories.json', 'users.json'
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    @categories = new Thorax.Collections.Categories json['categories.json'], parse: true
    @view = new Thorax.Views.Dashboard collection: @categories
    @view.render()

  it 'renders the categories', ->
    expect(@view.$el).toContainText @categories.first().get('category')

describe 'Results View', ->
  beforeEach ->
    json = loadJSONFixtures 'query.json', 'queries/patient_results.json', 'users.json'
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    @providerId = json['queries/patient_results.json'][0].value.provider_performances[0].provider_id
    @query = new Thorax.Models.Query $.extend(true, {}, json['query.json']), {parent: null}
    @measureId = @query.get('measure_id')
    @resultsViewWithProvider = new Thorax.Views.ResultsView model: @query, id: @measureId, provider_id: @providerId
    @resultsViewWithProvider.render()

  it 'links to the proper patient result view on provider', ->
    expect(@resultsViewWithProvider.$('a')).toHaveAttr 'href', "#measures/#{@measureId}/providers/#{@providerId}/patient_results"

  it 'abbreviates large fractions', ->
    result = $.extend {}, @query.get('result'), {NUMER: 7874}
    @query.set 'result', result
    expect(@resultsViewWithProvider.$('.numerator')).toContainText '7.9k'
