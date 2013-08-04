class Model.User extends Lib.Model

class Model.CurrentUser extends Model.User
  initialize: ->
    @on 'change', ->
      localStorage.currentUser = JSON.stringify(@toJSON())

  isLoggedIn: -> @has('id')

  loadFromCache: ->
    return if 'currentUser' not of localStorage
    @set(JSON.parse(localStorage.currentUser))

class Collection.Friends extends Lib.Collection
  url: '/friends'
  parse: (json) -> json.friends
