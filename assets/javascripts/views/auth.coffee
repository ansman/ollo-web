class View.Auth extends Lib.View
  id: 'auth'
  template: 'auth'
  events:
    'click .connect': 'connect'

  render: ->
    @spinner = new View.Spinner()
    @$el.append(@spinner.render().el)
    app.facebook.done =>
      @spinner.close()
      super
    return this

  connect: ->
    FB.login (response) =>
      return if not response.authResponse
      @renderConnected()
      app.authentication.login(response.authResponse.accessToken).done ->
        app.navigate('me')

  renderConnected: ->
    @$el.html(JST['auth/connected']())
      # return

      # FB.api '/me', ({first_name}) ->
      #   FB.api '/me/friends', ({data}) ->
      #     alert("Hi there, #{first_name}!\nYou have #{data.length} friends.")
    #


  # initialize: ->
  #   @request = app.get('/ping')

  # onRender: ->
  #   @spinner = new View.Spinner()
  #   @$el.append(@spinner.render().el)

  #   @request.done (response) =>
  #     @spinner.close()
  #     @$el.text("The server said #{response}")
