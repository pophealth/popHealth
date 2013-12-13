class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  name
  formatted_effective_time: -> format_time @model.get('effective_time')
  # The maskDate helper is called from this file since calling it from the patient show file 
  # causes the format_time function to be printed to the screen instead of a proper result.
  formatted_birthdate: -> Handlebars.helpers.maskDate format_time @model.get('birthdate')

  # Helper function for date/time conversion
  format_time = (time) -> moment(time).format('MM/DD/YYYY') if time