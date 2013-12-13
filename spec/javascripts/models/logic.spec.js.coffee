describe 'measure logic', ->
  beforeEach ->
    @json = getJSONFixture 'submeasure.json'
    @submeasure = new Thorax.Models.Submeasure @json, parse: true

  describe 'DataCriteria', ->
    beforeEach ->
      @dataCriteria = @submeasure.get('data_criteria')
    it 'creates criteria with a key as its ID', ->
      # FIXME use @json.hqmf_document.data_criteria? which has a different format
      key = _(@json.hqmf_document.data_criteria).keys()[0]
      dcModel = @dataCriteria.get(key)
      expect(dcModel).toBeInstanceOf Thorax.Models.DataCriteria

    describe 'temporal references', ->
      it 'can reference the MeasurePeriod', ->
        dcWithTemporalReferences = @dataCriteria.detect (dc) ->
          dc.has('temporal_references') and dc.get('temporal_references').first().get('reference') is 'MeasurePeriod'
        temporalReference = dcWithTemporalReferences.get('temporal_references').first()
        expect(temporalReference.reference()).toEqual 'MeasurePeriod'

      it 'can reference other data criteria', ->
        dcWithTemporalReferences = @dataCriteria.detect (dc) ->
          dc.has('temporal_references') and dc.get('temporal_references').first().get('reference') isnt 'MeasurePeriod'
        temporalReference = dcWithTemporalReferences.get('temporal_references').first()
        ref = temporalReference.reference()
        expect(ref).toBeInstanceOf Thorax.Models.DataCriteria

    describe 'child criteria', ->
      beforeEach ->
        dcWithChildCriteria = @dataCriteria.detect (dc) -> dc.has('children_criteria')
        @childCriteria = dcWithChildCriteria.get('children_criteria').first()
      it 'has all the attributes of the referenced criteria', ->
        dataCriteria = @dataCriteria.get(@childCriteria.id)
        expect(@childCriteria.get('title')).toEqual dataCriteria.get('title')
        expect(_(@childCriteria.toJSON()).omit('temporal_references')).toDeeplyEqual _(dataCriteria.toJSON()).omit('temporal_references')
      it 'only has an ID attribute', ->
        expect(_(@childCriteria.attributes).keys()).toEqual ['id']


  describe 'Population', ->
    beforeEach ->
      @population = @submeasure.get('NUMER')
    it 'contains a set of preconditions', ->
      expect(@population.get('preconditions')).toBeInstanceOf Thorax.Collections.Preconditions

    describe 'Precondition', ->
      beforeEach ->
        @precondition = @population.get('preconditions').first()

      it 'can get a reference back to its submeasure', ->
        expect(@precondition.submeasure()).toEqual @submeasure
        expect(@precondition.get('preconditions').first().submeasure()).toEqual @submeasure

      it 'can reference a data criteria', ->
        # see submeasure.json to follow structure; this references a precondition that has a data criteria reference
        leafPrecondition = @precondition.get('preconditions').first().get('preconditions').first()
        dataCriteria = leafPrecondition.reference()
        expect(dataCriteria.id).toEqual 'EncounterPerformedOfficeVisit_precondition_122'
