`import Ember from 'ember';`

BasicAdapter = Ember.Object.extend
  name: 'basic'

  sendMessage: ->

  onMessageReceived: (callback) ->
    @get('_messageCallbacks').pushObject callback

  _messageCallbacks: (->
    []
  ).property()

  _pendingMessages: (->
    []
  ).property()

  _isReady: false

  _messageReceived: (message) ->
    if !@_isReady and message.type is 'general:applicationBooted'
      @onConnectionReady()
    else
      @get('_messageCallbacks').forEach (callback) ->
        callback.call null, message

  # If other side not ready, store messages
  send: (options) ->
    if @_isReady
      @sendMessage.apply(@, arguments)
    else
      @get('_pendingMessages').push(options)

  # Called when the connection is set up.
  # Flushes the pending messages.
  onConnectionReady: ->
    messages = @get('_pendingMessages')
    messages.forEach (options) =>
      @sendMessage(options)

    messages.clear()
    @_isReady = true


`export default BasicAdapter;`
