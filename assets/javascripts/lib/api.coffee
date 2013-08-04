buildURL = (endpoint) -> "#{app.config.apiURL}#{endpoint}"

handleSuccess = _.bind(JSON.parse, JSON)
handleError = (jqXHR) -> console?.error(jqXHR.responseText)

_.extend app,
  get: (endpoint, options) ->
    app.request('get', endpoint, options)

  post: (endpoint, data, options) ->
    app.request('post', endpoint, _.extend({}, options, data: data))

  put: (endpoint, data, options) ->
    app.request('put', endpoint, _.extend({}, options, data: data))

  delete: (endpoint, options) ->
    app.request('delete', endpoint, options)

  request: (method, endpoint, options={}) ->
    url = buildURL(endpoint)
    xhr = $.ajax url, _.extend {}, options,
      contentType: 'application/json'
      crossDomain: true
      dataType: 'text'
      type: method.toUpperCase()
      data: JSON.stringify(options.data) if options.data
      success: null

    defer = xhr.then(handleSuccess, handleError)
    defer.done(options.success)
    defer.always(options.complete)
    defer.fail(options.error)
    return defer
