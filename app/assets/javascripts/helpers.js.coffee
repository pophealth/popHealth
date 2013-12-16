# Helper for replacing all but the first character of a name with x's 
# if the user has chosen to mask PHI data in settings.
Handlebars.registerHelper 'maskName', (value) -> 
	maskStatus = PopHealth.currentUser.maskStatus()
	if value && maskStatus
		return value[0]+"xxxxxx"
	else
		return value

# Helper for replacing all but the year of birth for a patient with x's
# if the user has chosen to mask PHI data in settings.
Handlebars.registerHelper 'maskDate', (value) -> 
	maskStatus = PopHealth.currentUser.maskStatus()
	if value && maskStatus
		return value.replace(/[MD]/g, 'x')
	else
		return value