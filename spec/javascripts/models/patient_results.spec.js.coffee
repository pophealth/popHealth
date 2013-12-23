describe 'PatientResults', ->
  beforeEach ->
    @json = getJSONFixture 'queries/patient_results.json'

  describe 'Collection', ->
    beforeEach ->      
      jasmine.Ajax.install()
      @collection = new Thorax.Collections.PatientResults @json[0...2], parse: true, parent: jasmine.createSpyObj('parent', ['url'])

    afterEach ->
      jasmine.Ajax.uninstall()

    it 'can fetch additional pages', ->
      expect(@collection.length).toEqual 2
      @collection.fetchNextPage(perPage: 2)
      jasmine.Ajax.requests.mostRecent().response({responseText: JSON.stringify(@json[2...4]), status: 200})
      expect(@collection.page).toEqual 2
      expect(@collection.length).toEqual 4

  describe 'Model', ->
    it 'should correct birthdate to milliseconds', ->
      pr = new Thorax.Models.PatientResult @json[0], parse: true
      expect(pr.get('birthdate')).toEqual(259736400000)