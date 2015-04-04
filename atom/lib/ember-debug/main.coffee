AtomAdapter = require './adapters/atom'
Port = require './port'
RouteDebug = require './route-debug'
GeneralDebug = require './general-debug'

Ember = window.Ember

module.exports = EmberDebug = Ember.Object.extend
  application: null
  appWindow: null

  Port: Port
  Adapter: AtomAdapter

  start: ->
    @set('application', @getApplication()) unless @get('application')
    @startModule('adapter', @Adapter)
    @startModule('port', @Port)

    @startModule('route', RouteDebug)
    @startModule('general', GeneralDebug)

  getApplication: ->
    Ember = @get('appWindow').Ember
    namespaces = Ember.Namespace.NAMESPACES
    application = undefined

    namespaces.forEach (namespace) ->
      if namespace instanceof Ember.Application
        application = namespace
        return false
      return

    application

  startModule: (prop, Module) ->
    @set(prop, Module.create({ namespace: @ }))
