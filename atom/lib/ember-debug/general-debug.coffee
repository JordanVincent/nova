PortMixin = require './mixins/port-mixin'

Ember = window.Ember
computed = Ember.computed
oneWay = computed.oneWay

module.exports = Ember.Object.extend PortMixin,
  namespace: null
  portNamespace: 'general'
  port: oneWay('namespace.port').readOnly()

  booted: (->
    @sendBooted()
  ).on('init')

  sendBooted: ->
    @sendMessage 'applicationBooted'
