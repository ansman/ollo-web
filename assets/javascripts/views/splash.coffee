class View.Splash extends Lib.View
  template: 'splash'
  id: 'splash'
  className: 'slider'

  initialize: ->
    try
      @days = localStorage.days and JSON.parse(localStorage.days)
    catch e
    @days ||= {}

  onRender: ->
    @$el.tap('.day', @toggleDay)
    @$el.tap('.next', @next)

    for day, selected of @days when selected
      @$el.find(".day.#{day}").addClass("selected")
    @updateNext()

  onShow: ->
    startSlide = 0
    try
      if localStorage.days and _.any(JSON.parse(localStorage.days))
        startSlide = 4
    catch e

    @swipe = Swipe @$el.find('.swipe').get(0),
      startSlide: startSlide
      continuous: false
      callback: @swiped

    @swiped()
    @next(false) if _.any(@days)

  swiped: =>
    @$el.find(".indicators li")
      .removeClass('active')
      .filter(":nth-child(#{@swipe.getPos()+1})")
        .addClass('active')

    if @swipe.getPos() + 1 is @swipe.getNumSlides()
      @$el.addClass('last-slide')
    else
      @$el.removeClass('last-slide')

  toggleDay: (ev) =>
    ev.preventDefault()
    $(ev.currentTarget).toggleClass('selected')
    @updateNext()

  updateNext: ->
    next = @$el.find('.next')
    if @$el.find('.day.selected').length
      animation = not next.is('.available')
      next.addClass('available')
    else
      animation = next.is('.available')
      next.removeClass('available')

  next: (animate=true) =>
    return if @$el.find('.day.selected').length is 0
    return if not @$el.is('.last-slide')

    @days =
      day1: @$el.find('.day.day1').is('.selected')
      day2: @$el.find('.day.day2').is('.selected')
      day3: @$el.find('.day.day3').is('.selected')

    localStorage.days = JSON.stringify(@days)
    questions = new View.Questions(splash: this, days: @days)

    if animate
      Lib.animator.forward(this, questions)
    else
      @$el.detach()
      $('#app').append(questions.render().el)
      questions.show()
