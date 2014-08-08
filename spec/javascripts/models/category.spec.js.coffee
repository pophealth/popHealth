describe 'Categories', ->
  beforeEach ->
    categoriesJSON = getJSONFixture 'categories.json'
    @categories = new Thorax.Collections.Categories categoriesJSON, parse:true

  it 'finds measures without submeasures', ->
    expect(@categories.findSubmeasure("8A4D92B2-3927-D7AE-0139-366C49F93102").get('name')).toBe "Maternal Depression Screening"

  it 'finds measures with submeasures', ->
    expect(@categories.findSubmeasure("40280381-3D61-56A7-013E-8A3638093344", "a").get('name')).toBe "Depression Utilization of the PHQ-9 Tool"
    expect(@categories.findSubmeasure("40280381-3D61-56A7-013E-8A3638093344", "a").get('short_subtitle')).toBe "Sep-Dec"

  it 'finds top-level measures', ->
    measure = @categories.findMeasure("40280381-3D61-56A7-013E-8A3638093344")
    expect(measure.get('name')).toBe "Depression Utilization of the PHQ-9 Tool"
    expect(measure.get('submeasures').get('a').get('short_subtitle')).toBe 'Sep-Dec'
