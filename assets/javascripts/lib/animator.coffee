Lib.animator =
  animating: false
  forward: (fromView, toView) ->
    return if @animating
    @animating = true

    els = fromView.$el.add(toView.$el)
    $("#app").append(toView.render().el)
    toView.show()

    _.defer -> _.defer ->
      els.addClass("slide-up animate")
      fromView.$el.addTransitionCallback (ev) ->
        els.removeClass("slide-up animate")
        fromView.$el.detach()
        Lib.animator.animating = false

  back: (fromView, toView) ->
    return if @animating
    @animating = true
    els = fromView.$el.add(toView.$el)
    $("#app").prepend(toView.$el)
    els.addClass('slide-up')

    _.defer -> _.defer ->
      els.addClass("animate")
      _.defer -> _.defer -> els.removeClass("slide-up")
      fromView.$el.addTransitionCallback ->
        els.removeClass("animate")
        fromView.close()
        Lib.animator.animating = false
