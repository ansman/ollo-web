defer = new $.Deferred()
app.facebook = defer.promise()

window.fbAsyncInit = ->
  FB.init
    appId      : app.config.facebookAppID
    channelUrl : "//#{app.config.domain}/facebook-channel"
    status     : false
    cookie     : true

  defer.resolve()
