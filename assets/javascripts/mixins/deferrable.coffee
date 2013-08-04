Mixin.Deferrable =
  setupDefer: ->
    @_defer = new jQuery.Deferred()
    @_defer.promise(this)
    @_fetchCount = 0

    # The reason for not using this.state() is 'resolved' instead is that
    # if we resolve before setting the attributes/models the listeners listening
    # to defer.done will get an empty model/collection and if we set before we
    # resolve the reset/change event will fire but the model will still not be
    # fetched
    @_fetched = false

    @resolveFetch() if @isNew()

  resolveFetch: ->
    @_fetched = true
    @_defer.resolve(this)

  rejectFetch: (response) -> @_defer.rejectWith(this, this, response)
  isBeingFetched: -> @_fetchCount > 0
  isFetched: -> @_fetched
  fetched: -> @done(arguments...)

  ensureFetched: (callback) ->
    @refresh() unless @isFetched()
    @done(callback)
    this

  refresh: ->
    @fetch() unless @isBeingFetched()
    this
