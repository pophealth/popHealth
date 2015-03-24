describe 'QueryView', ->
  beforeEach ->
    json = loadJSONFixtures 'query.json', 'submeasure.json', 'users.json'
    Backbone.history.start()
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    jasmine.Ajax.install()
    @json = getJSONFixture 
    submeasure = new Thorax.Models.Submeasure json['submeasure.json'], parse: true
    @query = new Thorax.Models.Query {measure_id: submeasure.get('id'), sub_id: submeasure.get('sub_id'), effective_date: json['users.json'][0].effective_date}, parent: submeasure
    @queryView = new Thorax.Views.QueryView model: @query
    # respond to all query requests, as there will be several views with the query as its model
    queryJson = json['query.json']
    for request in jasmine.Ajax.requests.filter('/api/queries')
      request.response responseText: JSON.stringify(queryJson), status: 200
    @queryView.render()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'fetches query', ->
    # @queryView.appendTo('body')
    expect(@queryView.$('.numerator')).toContainText 2
    expect(@queryView.$('.denominator')).toContainText 4
