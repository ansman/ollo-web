class Me extends Lib.View
  template: 'me'

class Friends extends Lib.View
  template: 'friends'
  initialize: ->
    @listenTo(@collection, 'sync', @render)

  render: ->
    spinner = new View.Spinner()
    @$el.html(spinner.render().el)
    @collection.done =>
      spinner.close()
      super
    this

class Router.Auth extends Backbone.Router
  routes:
    'login': 'login'
    'logout': 'logout'
    'friends': 'friends'
    'me': 'me'
    'map': 'map'
    '': 'splash'
    'oauth-response': 'oauthResponse'

  logout: ->
    app.authentication.logout()

  login: ->
    app.show(new View.Auth())

  friends: app.authentication.ensure ->
    app.collection.friends.fetch()
    app.show(new Friends(collection: app.collection.friends))

  me: app.authentication.ensure ->
    app.show(new Me())

  splash: ->
    app.show(new View.Splash())

  map: ->
    app.show(new View.Map())

  oauthResponse: ->
    app.authentication.login(app.params.access_token).done ->
      app.navigate('/map', replace: true)
