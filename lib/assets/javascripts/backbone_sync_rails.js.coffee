Backbone.sync = _.wrap Backbone.sync, (sync, method, model, options) ->
  # only need a token for non-get requests
  if method in ['create', 'update', 'delete']
    options.beforeSend = _.wrap options.beforeSend, (beforeSend, xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
      beforeSend(xhr) if beforeSend
  # proxy the call to the old sync method
  sync method, model, options
