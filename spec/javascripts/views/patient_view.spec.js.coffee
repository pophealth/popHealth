describe 'PatientView', ->
  beforeEach ->
    json = loadJSONFixtures('patients.json', 'users.json')
    window.PopHealth.currentUser = new Thorax.Models.User $.extend(true, {}, json['users.json'][0])
    @patient = new Thorax.Models.Patient json['patients.json'][0]
    @patientView = new Thorax.Views.PatientView model: @patient
    @patientView.render()

  it 'renders the patient\'s basic data', ->
    expect(@patientView.$el).toContainText @patient.get('first')
    expect(@patientView.$el).toContainText @patient.get('last')
    expect(@patientView.$el).toContainText @patient.get('medical_record_number')
    expect(@patientView.$el).toContainText @patient.get('gender')

  it 'formats the effective time correctly', ->
    expect(@patientView.formattedEffectiveTime()).toEqual("01/16/1970")

  it 'formats the birthday correctly', ->
    expect(@patientView.formattedBirthdate()).toEqual("12/21/1969")