Backbone.sync = (method, model, options={}) ->
  method = switch method
    when 'create' then 'post'
    when 'read' then 'get'
    when 'update' then 'put'
    when 'delete' then 'delete'

  endpoint = _.result(model, 'url')
  data = model.toJSON() if method in ['post', 'put']

  model._fetchCount++ if method is 'get'

  app.request method, endpoint, _.extend {}, options,
    data: data
    success: (resp) ->
      if method is 'get'
        model._fetchCount--
        # Needs to be done before resolveFetch
        model._fetched = true
      options.success(resp)
      model.resolveFetch() if method is 'get'
