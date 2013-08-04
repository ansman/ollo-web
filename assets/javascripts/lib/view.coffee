class Lib.View extends Backbone.View
  render: ->
    @$el.html(JST[@template](@serializeData())) if @template
    @onRender?()
    return this

  serializeData: ->
    _.extend @options,
      currentUser: app.currentUser
      model: @model
      collection: @collection
      view: this

  close: ->
    @remove()
    @onClose?()

  show: ->
    @onShow?()
