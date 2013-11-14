class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  formatted_effective_time: -> format_time @model.get('effective_time')
  formatted_birthdate: -> format_time @model.get('birthdate')

  # Helper function for date/time conversion
  format_time = (time) -> moment(time).format('MM/DD/YYYY') if time