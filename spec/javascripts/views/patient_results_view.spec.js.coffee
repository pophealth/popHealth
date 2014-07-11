describe 'PatientResultsView', ->
  beforeEach ->
    json = loadJSONFixtures 'query.json', 'submeasure.json', 'queries/patient_results.json', 'users.json'
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    jasmine.Ajax.install()
    @json = getJSONFixture 
    submeasure = new Thorax.Models.Submeasure json['submeasure.json'], parse: true
    query = new Thorax.Models.Query json['query.json'], parse: true, parent: submeasure
    @patientResultsView = new Thorax.Views.PatientResultsView query: query
    jasmine.Ajax.requests.mostRecent().response responseText: JSON.stringify(json['queries/patient_results.json'][2...4]), status: 200

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'renders the patient list', ->
    expect(@patientResultsView.$el).toContainText @patientResultsView.collection.first().get('last')
