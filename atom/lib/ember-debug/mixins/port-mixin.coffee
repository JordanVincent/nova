Ember = window.Ember
Mixin = Ember.Mixin

module.exports = Mixin.create
  port: null
  messages: {}
  portNamespace: null

  init: ->
    @setupPortListeners()

  willDestroy: ->
    @removePortListeners()

  sendMessage: (name, message) ->
    @get('port').send(@messageName(name), message)

  setupPortListeners: ->
    port = @get('port')
    messages = @get('messages')

    for name of messages
      if messages.hasOwnProperty(name)
        port.on @messageName(name), this, messages[name]


  removePortListeners: ->
    port = @get('port')
    messages = @get('messages')

    for name of messages
      if (messages.hasOwnProperty(name))
        port.off(@messageName(name), this, messages[name])

  messageName: (name) ->
    messageName = name

    if (@get('portNamespace'))
      messageName = @get('portNamespace') + ':' + messageName

    messageName

