class Lib.Collection extends Backbone.Collection
  Mixin.includeMixinBase(this)
  @include Mixin.Deferrable

  isNew: -> false

  constructor: ->
    @setupDefer()
    super
