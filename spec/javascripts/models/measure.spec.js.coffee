describe 'Measure', ->
  beforeEach ->
    categories = getJSONFixture 'categories.json'
    @normalMeasure = new Thorax.Models.Measure categories[0].measures[0], parse: true
    @measureWithSubIDs = new Thorax.Models.Measure categories[2].measures[1], parse: true

  it 'tracks submeasures', ->
    expect(@normalMeasure.get('submeasures').length).toBe 1
    expect(@measureWithSubIDs.get('submeasures').length).toBe 3

  describe 'submeasures', ->
    beforeEach ->
      @json = getJSONFixture 'submeasure.json'
      @submeasure = new Thorax.Models.Submeasure @json, parse: true

    it 'creates a population for each population type', ->
      # FIXME consider adding DENEXCEP to fixture, this isn't tested otherwise
      for type in ['DENEX', 'NUMER', 'IPP', 'DENOM']
        expect(@submeasure.get(type)).toBeInstanceOf Thorax.Models.Population

    it "doesn't create populations for population types that aren't part of this submeasure", ->
      for type in ['DENEX', 'NUMER', 'IPP', 'DENOM']
        expect(@submeasure.get(type).get('original_type')).toEqual "#{type}_1"
