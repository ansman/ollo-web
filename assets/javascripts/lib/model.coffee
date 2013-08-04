class Lib.Model extends Backbone.Model
  Mixin.includeMixinBase(this)
  @include Mixin.Deferrable

  constructor: ->
    @setupDefer()
    super
