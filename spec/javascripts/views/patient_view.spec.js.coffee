describe 'PatientView', ->
  beforeEach ->
    patients = getJSONFixture('patients.json')
    @patient = new Thorax.Models.Patient patients[0]
    @patientView = new Thorax.Views.PatientView model: @patient
    @patientView.render()

  it 'renders the patient\'s basic data', ->
    expect(@patientView.$el).toContainText @patient.get('first')
    expect(@patientView.$el).toContainText @patient.get('last')

  it 'formats the effective time correctly', ->
    expect(@patientView.$el).toContainText "16 Jan 1970"

  it 'formats the birthday correctly', ->
    expect(@patientView.$el).toContainText "21 Dec 1969"