Backbone.sync = _.wrap Backbone.sync, (sync, method, model, success, error) ->
  # only need a token for non-get requests 
  if method in ['create', 'update', 'delete']
    # grab the token from the meta tag rails embeds
    authOptions = {}
    authOptions[$("meta[name='csrf-param']").attr('content')] = $("meta[name='csrf-token']").attr('content')
    # set it as a model attribute without triggering events 
    model.set(authOptions, silent: true)
  # proxy the call to the old sync method 
  sync(method, model, success, error)
