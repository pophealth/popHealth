class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  formatted_effective_time: -> format_time @model.get('effective_time')

  formatted_birthdate: -> format_time @model.get('birthdate'), maskDate "MM/DD/YYYY"

  # Helper function for date/time conversion
  format_time = (time, format) -> moment(time).format(format || 'MM/DD/YYYY') if time

  maskDate = (value) -> 
    maskStatus = PopHealth.currentUser.maskStatus()
    if value && maskStatus
      return value.replace(/[MD]/g, 'x')
    else
      return value