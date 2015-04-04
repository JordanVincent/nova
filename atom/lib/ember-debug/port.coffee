Ember = window.Ember
oneWay = Ember.computed.oneWay

module.exports = Ember.Object.extend Ember.Evented,
  adapter: oneWay('namespace.adapter').readOnly()

  init: ->
    @get('adapter').onMessageReceived (message) =>
      @trigger message.type, message

  send: (messageType, options) ->
    options.type = messageType
    options.from = 'inspectedWindow'
    @get('adapter').send options