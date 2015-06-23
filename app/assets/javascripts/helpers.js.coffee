window.PopHealth ||= {}
PopHealth.Helpers ||= {}

_.extend PopHealth.Helpers,
  # Helper for replacing all but the first character of a name with x's
  # if the user has chosen to mask PHI data in settings.
  maskName: (value) ->
    maskStatus = PopHealth.currentUser.maskStatus()
    if value && maskStatus
      return "#{value[0]}xxxxxx"
    else
      return value

  # Helper used to replace MM/DD/YYYY or MMM DD YYYY with xx/xx/YYYY or
  # xxx xx YYYY if mask PHI data is enabled in settings.
  maskDateFormat: (value) ->
    maskStatus = PopHealth.currentUser.maskStatus()
    if value && maskStatus
      return value.replace(/[MD]/g, 'x')
    else
      return value

  formatNumber: (value) ->
    return String(value).replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    
  formatMRN: (mrn) ->
    length = if mrn.indexOf("-") is -1 then mrn.length-1 else mrn.indexOf("-")
    return mrn.substring(0, length)
    
##### Handlebars Helpers
Handlebars.registerHelper 'join', (list, options = {}) ->
  mappable = if list instanceof Backbone.Collection then list else _(list)
  mappable.map(
    (item) ->
      item = item.attributes if item instanceof Backbone.Model
      if options.fn then options.fn(item).trim() else item.toString()
  ).join(options.hash.delimiter)

Handlebars.registerHelper 'formatNumeral', (number, format) -> numeral(number).format(format)
Handlebars.registerHelper 'log', -> console.log arguments...
