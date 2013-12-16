window.PopHealth ||= {}
PopHealth.Helpers ||= {}

# Helper for replacing all but the first character of a name with x's 
# if the user has chosen to mask PHI data in settings.
PopHealth.Helpers.maskName = (value) -> 
  maskStatus = PopHealth.currentUser.maskStatus()
  if value && maskStatus
    return value[0]+"xxxxxx"
  else
    return value

# Helper used to replace MM/DD/YYYY or MMM DD YYYY with xx/xx/YYYY or
# xxx xx YYYY if mask PHI data is enabled in settings.
PopHealth.Helpers.maskDateFormat = (value) ->
  maskStatus = PopHealth.currentUser.maskStatus()
  if value && maskStatus
    return value.replace(/[MD]/g, 'x')
  else
    return value