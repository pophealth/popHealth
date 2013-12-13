describe 'PatientResults', ->
  describe 'Collection', ->
    beforeEach ->
      @json = getJSONFixture 'queries/patient_results.json'
      jasmine.Ajax.useMock()
      @collection = new Thorax.Collections.PatientResults @json[0...2], parse: true, parent: jasmine.createSpyObj('parent', ['url'])

    it 'can fetch additional pages', ->
      @collection.fetchNextPage(perPage: 2)
      mostRecentAjaxRequest().response {responseText: JSON.stringify(@json[2...4]), status: 200}
      expect(@collection.toJSON()).toEqual _(@json[0...4]).map (r) -> r.value
      expect(@collection.page).toEqual 2
