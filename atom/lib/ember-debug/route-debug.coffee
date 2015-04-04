PortMixin = require './mixins/port-mixin'

Ember = window.Ember
classify = Ember.String.classify
dasherize = Ember.String.dasherize
computed = Ember.computed
oneWay = computed.oneWay
observer = Ember.observer
later = Ember.run.later

module.exports = Ember.Object.extend PortMixin,
  portNamespace: 'route'
  namespace: null
  port: oneWay('namespace.port').readOnly()
  application: oneWay('namespace.application').readOnly()

  router: ( ->
    @get('application.__container__').lookup('router:main')
  ).property('application')

  messages:
    getRoutes: ->
      @sendRoutes()

  sendRoutes: ->
    routeNames = @get('router.router.recognizer.names')

    routeNs = Ember.A()
    for routeName of routeNames
      if !routeNames.hasOwnProperty(routeName)
        continue
      route = routeNames[routeName]
      routeNs.pushObject routeName

    @sendMessage('routes', { routes: routeNs })