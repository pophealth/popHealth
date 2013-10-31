class Thorax.Views.PatientView extends Thorax.View
  template: JST['patients/show']
  formatted_effective_time: -> moment(@model.get('effective_time')).format('MM/DD/YYYY')
  formatted_birthdate: -> moment(@model.get('birthdate')).format('MM/DD/YYYY')