app.addInitializer ->
  _.each Router, (cls, name) ->
    app.router[name.toLowerCase()] = new cls()
