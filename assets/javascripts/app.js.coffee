#= require hamlcoffee
#= require ./vendor/underscore
#= require ./vendor/backbone
#= require_tree ./vendor
#= require_self
#= require_tree ./mixins
#= require_tree ./lib
#= require_tree ./models
#= require_tree ./routers
#= require_tree ./initializers
#= require_tree ./templates
#= require_tree ./views

window.app =
  initializers: []
  addInitializer: (func) -> app.initializers.push(func)
  start: (@params) ->
    @parseHash()
    _.each(@initializers, (func) -> func(@params))
    Backbone.history.start(pushState: true)

  parseHash: ->
    hash = window.location.hash
    _.each hash[1..].split('&'), (part) =>
      [key, val] = part.split('=')
      @params[key] = val

  navigate: (fragment, options={}) ->
    Backbone.history.navigate(fragment, _.defaults(options, trigger: true))

  buildURL: (path) -> "#{app.config.baseURL}#{path}"

  show: (view) ->
    app.currentView?.close()
    $('#app')
      .empty()
      .append(view.render().el)
    app.currentView = view
    view.show()

for namespace in ['Router', 'View', 'Lib', 'Model', 'Collection', 'Mixin']
  window[namespace] ||= {}

for namespace in ['router', 'collection']
  app[namespace] ||= {}
