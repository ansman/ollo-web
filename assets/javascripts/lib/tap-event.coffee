$.fn.tap = (selector, callback) ->
  callback = selector if not callback
  if Modernizr.touch
    new TapEventHandler(this, selector, callback)
  else
    @on('click', _.compact([selector, callback])...)

  return this

class TapEventHandler
  constructor: (@el, @selector, @callback) ->
    @on('touchstart', @onTouchStart)

  on: (ev, func) ->
    if @selector
      @el.on(ev, @selector, func)
    else
      @el.on(ev, func)

  off: (ev, func) ->
    if @selector
      @el.off(ev, @selector, func)
    else
      @el.off(ev, func)

  onTouchStart: (ev) =>
    ev.stopPropagation()
    @moved = false
    @on('touchmove', @onTouchMove)
    @on('touchend', @onTouchEnd)
    return

  onTouchMove: =>
    @moved = true
    return

  onTouchEnd: (ev) =>
    ev.stopPropagation()
    @off('touchmove', @onTouchMove)
    @off('touchend', @onTouchEnd)
    return if @moved
    @callback(ev)
    return
