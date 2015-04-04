`import Ember from 'ember';`

K = Ember.K

BasicAdapter = Ember.Object.extend
  name: 'basic'

  sendMessage: ->

  onMessageReceived: (callback) ->
    @get('_messageCallbacks').pushObject callback

  _messageCallbacks: (->
    []
  ).property()

  _messageReceived: (message) ->
    @get('_messageCallbacks').forEach (callback) ->
      callback.call null, message
  willReload: K
  canOpenResource: false

  openResource: ->

`export default BasicAdapter;`
