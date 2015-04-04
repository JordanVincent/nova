`import Ember from 'ember';`

Port = Ember.Object.extend Ember.Evented,

  init: ->
    @get('adapter').onMessageReceived (message) =>
      @trigger(message.type, message)

  send: (type, message) ->
    message = message or {}
    message.type = type
    message.from = 'devtools'
    @get('adapter').sendMessage message

`export default Port;`