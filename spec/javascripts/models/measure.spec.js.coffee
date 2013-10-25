describe 'Measure', ->
  beforeEach ->
    categories = getJSONFixture 'categories.json'
    @normalMeasure = new Thorax.Models.Measure categories[0].measures[0], parse: true
    @measureWithSubIDs = new Thorax.Models.Measure categories[2].measures[1], parse: true

  it 'tracks submeasures', ->
    expect(@normalMeasure.get('submeasures').length).toBe 1
    expect(@measureWithSubIDs.get('submeasures').length).toBe 3
