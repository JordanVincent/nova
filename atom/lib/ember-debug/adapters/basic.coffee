Ember = window.Ember
computed = Ember.computed
$ = Ember.$
RSVP = Ember.RSVP
Promise = RSVP.Promise

module.exports = Ember.Object.extend

  sendMessage: ->

  onMessageReceived: (callback) ->
    @get('_messageCallbacks').pushObject callback

  _messageReceived: (message) ->
    @get('_messageCallbacks').forEach (callback) ->
      callback.call null, message

  _messageCallbacks: Ember.computed(->
    Ember.A()
  ).property()

  send: (options) ->
    @sendMessage.apply @, arguments
