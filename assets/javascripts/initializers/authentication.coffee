app.addInitializer ->
  app.currentUser = new Model.CurrentUser()
  app.currentUser.loadFromCache()
