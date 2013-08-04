#= require hamlcoffee
#= require ./vendor/underscore
#= require ./vendor/backbone
#= require_self
#= require_tree ./routers
#= require_tree ./initializers
#= require_tree ./templates
#= require_tree ./lib
#= require_tree ./views

window.app =
  initializers: []
  addInitializer: (func) -> app.initializers.push(func)
  start: ->
    _.each(@initializers, (func) -> func())
    Backbone.history.start()
  navigate: (fragment, options={}) ->
    Backbone.history.navigate(fragment, _.defaults(options, trigger: true))

  show: (view) ->
    app.currentView?.close()
    $('body').append(view.render().el)

for namespace in ['Router', 'View', 'Lib']
  window[namespace] ||= {}

for namespace in ['router']
  app[namespace] ||= {}
