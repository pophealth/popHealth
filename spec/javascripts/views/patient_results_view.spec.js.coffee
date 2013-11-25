describe 'PatientResultsView', ->
  beforeEach ->
    queryJSON = getJSONFixture('query.json')
    query = new Thorax.Models.Query queryJSON, parse: true
    @patientResultsView = new Thorax.Views.PatientResultsView query: query 
    @patientResultsView.render()

  it 'renders the patient list', ->
    @patientResultsView.collection.each (r) =>
      expect(@patientResultsView.$el).toContainText r.get('last')