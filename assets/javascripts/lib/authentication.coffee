app.authentication =
  ensure: (func) -> (args...) ->
    if app.currentUser.isLoggedIn()
      func.apply(this, args)
    else
      app.navigate('login')

  login: (accessToken) ->
    defer = new $.Deferred()
    app.post('/auth/facebook', facebook_access_token: accessToken)
      .done ({user, access_token}) =>
        app.currentUser.set(_.extend({}, user, accessToken: accessToken))
        defer.resolve()
    return defer.promise()

  logout: ->
    localStorage.clear()
    window.location = '/login'
