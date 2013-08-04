app.addInitializer ->
  _.each Collection, (cls, name) ->
    app.collection[name.toLowerCase()] = new cls()
