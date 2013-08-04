class Lib.View extends Backbone.View
  render: ->
    @$el.html(JST[@template](@serializeData())) if @template
    return this

  serializeData: ->
    _.extend @options,
      model: @model
      collection: @collection
      view: this
