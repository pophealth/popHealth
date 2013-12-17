describe 'PatientView', ->
  beforeEach ->
    json = loadJSONFixtures('patients.json', 'users.json')
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    @patient = new Thorax.Models.Patient json['patients.json'][0], parse: true
    @patientView = new Thorax.Views.PatientView model: @patient
    @patientView.render()

  it 'renders the patient\'s basic data', ->
    expect(@patientView.$el).toContainText @patient.get('first')
    expect(@patientView.$el).toContainText @patient.get('last')

  it 'formats the effective time correctly', ->
    expect(@patientView.$el).toContainText '08 Oct 2013'

  it 'formats the birthday correctly', ->
    expect(@patientView.$el).toContainText '01 Feb 1942'

  describe 'when PHI is masked', ->
    beforeEach ->
      PopHealth.currentUser.get('preferences').mask_phi_data = true
      expect(PopHealth.currentUser.maskStatus()).toBeTruthy()
      @patientView.render()

    it 'formats effective time the same', ->
      expect(@patientView.$el).toContainText '08 Oct 2013'

    it 'masks the birthday', ->
      expect(@patientView.$el).toContainText 'xx xxx 1942'

    it 'masks the name', ->
      expect(@patientView.$el).toContainText "#{@patient.get('first')[0]}xxxxxx"
      expect(@patientView.$el).toContainText "#{@patient.get('last')[0]}xxxxxx"
