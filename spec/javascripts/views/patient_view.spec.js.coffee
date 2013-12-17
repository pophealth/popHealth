describe 'PatientView', ->
  beforeEach ->
    patients = getJSONFixture('patients.json')
    @patient = new Thorax.Models.Patient patients[0], parse: true
    @patientView = new Thorax.Views.PatientView model: @patient
    @patientView.render()

  it 'renders the patient\'s basic data', ->
    expect(@patientView.$el).toContainText @patient.get('first')
    expect(@patientView.$el).toContainText @patient.get('last')

  it 'formats the birthday correctly', ->
    expect(@patientView.$el).toContainText "01 Feb 1942"

  it 'renders language correctly', ->
    expect(@patientView.$el).toContainText "eng"

  it 'renders language correctly when it is not there', ->
    clonedPatient = _.clone(@patient.toJSON())
    clonedPatient.languages = []
    noLanguagePatient = new Thorax.Models.Patient clonedPatient, parse: true
    noLanguageView = new Thorax.Views.PatientView model: noLanguagePatient
    noLanguageView.render()
    expect(noLanguageView.$el).toContainText "Not Available"
