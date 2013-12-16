class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  formattedEffectiveTime: -> formatTime @model.get('effective_time')

  formattedBirthdate: -> formatTime @model.get('birthdate'), maskDate "MM/DD/YYYY"

  # Helper function for date/time conversion
  formatTime = (time, format) -> moment(time).format(format || 'MM/DD/YYYY') if time

  maskDate = (value) -> 
    maskStatus = PopHealth.currentUser.maskStatus()
    if value && maskStatus
      return value.replace(/[MD]/g, 'x')
    else
      return value