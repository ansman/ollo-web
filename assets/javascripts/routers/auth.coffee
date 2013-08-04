class Router.Auth extends Backbone.Router
  routes:
    '': 'auth'

  auth: ->
    app.show(new View.Auth())
