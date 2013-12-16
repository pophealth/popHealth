class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  formatted_effective_time: -> format_time @model.get('effective_time')
  # The maskDate helper is called from this file since calling it from the patient show file 
  # causes the format_time function to be printed to the screen instead of a proper result.
  formatted_birthdate: -> format_time @model.get('birthdate'), Handlebars.helpers.maskDate "MM/DD/YYYY"

  # Helper function for date/time conversion
  format_time = (time, format) -> moment(time).format(format || 'MM/DD/YYYY') if time