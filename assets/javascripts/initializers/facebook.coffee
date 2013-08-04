defer = new $.Deferred()
app.facebook = defer.promise()

window.fbAsyncInit = ->
  FB.init
    appId      : '573758559334502'
    channelUrl : "//#{app.config.domain}/facebook-channel"
    status     : false
    cookie     : true

  defer.resolve()
