$.fn.tap = (selector, callback) ->
  callback = selector if not callback
  if Modernizr.touch
    new TapEventHandler(this, selector, callback)
  else
    @on('click', _.compact([selector, callback])...)

  return this

class TapEventHandler
  constructor: (@el, @selector, @callback) ->
    @el.on('touchstart', @cb(@onTouchStart)...)

  cb: (callback) -> _.compact([@selector, callback])

  onTouchStart: (ev) =>
    ev.preventDefault()
    @moved = false
    @el.on('touchmove', @cb(@onTouchMove)...)
    @el.on('touchend', @cb(@onTouchEnd)...)
    return

  onTouchMove: =>
    @moved = true
    return

  onTouchEnd: (ev) =>
    return if @done
    @el.off('touchmove', @cb(@onTouchMove)...)
    @el.off('touchend', @cb(@onTouchEnd)...)
    return if @moved
    @callback(ev)
    return
