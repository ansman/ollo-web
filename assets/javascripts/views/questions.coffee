class View.Questions extends Lib.View
  template: 'questions'
  id: 'questions'
  className: 'slider'
  audio: null
  audioXHR: null

  onRender: ->
    @$el
      .tap('.answer', @toggleAnswer)
      .tap('.play', @playTapped)
      .tap('.back', @back)
      .tap('.trees', @login)

  onShow: ->
    @swipe = Swipe @$el.find('.swipe').get(0),
      startSlide: 0
      continuous: false
      callback: @swiped

    @swiped()

  swiped: =>
    @$el.find(".indicators li")
      .removeClass('active')
      .filter(":nth-child(#{@swipe.getPos()+1})")
        .addClass('active')

    if @swipe.getPos() + 1 < @swipe.getNumSlides()
      @$el.removeClass('last-slide')
    else
      @$el.addClass('last-slide')


  back: =>
    Lib.animator.back(this, @options.splash)

  toggleAnswer: (ev) =>
    had = $(ev.currentTarget).is('.selected')
    @$el.find('.answer').removeClass('selected')
    $(ev.currentTarget).addClass('selected') unless had

  login: =>
    FB.login ({authResponse}) ->
      return if not authResponse
      app.authentication.login(authResponse.accessToken).done ->
        app.navigate('/map')

  playTapped: (ev) =>
    ev.stopPropagation()
    button = $(ev.currentTarget)
    @audioXHR?.abort()
    @audio?.pause()
    @audio = @audioXHR = null
    wasPlaying = button.is('.playing')
    @$el.find('.playing').removeClass('playing')

    return if wasPlaying
    button.addClass('playing')
    @findAndPlayPreviewUrl(button.closest('.answer').find('.text').text().trim())

  findAndPlayPreviewUrl: (artist) ->
    data = $.param
      api_key: 'RQFHVHIXI568FNXGL'
      artist: artist
      results: 25
      format: 'jsonp'
      bucket: 'id:7digital-US'

    @audioXHR = $.ajax
      url: "https://developer.echonest.com/api/v4/song/search?#{data}&bucket=tracks"
      dataType: 'jsonp'

    @audioXHR.done (response) =>
      for s in response.response.songs
        for t in s.tracks
          if t.preview_url
            previewUrl = t.preview_url
            break
      @audio = new Audio(previewUrl.replace('http:', 'https:'))
      @audio.play()
      @audioXHR = null
