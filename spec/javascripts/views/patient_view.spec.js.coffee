describe 'PatientView', ->
  beforeEach ->
    patients = getJSONFixture('patients.json')
    @patient = new Thorax.Models.Patient patients[0]
    @patientView = new Thorax.Views.PatientView model: @patient
    @patientView.render()

  it 'renders the patient\'s basic data', ->
    expect(@patientView.$el).toContainText @patient.get('first')
    expect(@patientView.$el).toContainText @patient.get('last')
    expect(@patientView.$el).toContainText @patient.get('medical_record_number')
    expect(@patientView.$el).toContainText @patient.get('gender')

  it 'formats the effective time correctly', ->
    expect(@patientView.formatted_effective_time()).toEqual("01/16/1970")

  it 'formats the birthday correctly', ->
    expect(@patientView.formatted_birthdate()).toEqual("12/21/1969")