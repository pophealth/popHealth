class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  first: -> PopHealth.Helpers.maskName @model.get('first')

  last: -> PopHealth.Helpers.maskName @model.get('last')

  formattedEffectiveTime: -> formatTime @model.get('effective_time')

  formattedBirthdate: -> formatTime @model.get('birthdate'), PopHealth.Helpers.maskDateFormat "MM/DD/YYYY"

  # Helper function for date/time conversion
  formatTime = (time, format) -> moment(time).format(format || 'MM/DD/YYYY') if time