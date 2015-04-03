Ember = window.Ember

module.exports = EmberDebug = Ember.Object.extend
  application: null
  appWindow: null

  start: (appWindow) ->
    @set('appWindow', appWindow)
    @set('application', @getApplication()) unless @get('application')
    @test()

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

  test: ->
    routerMain = @get('application').__container__.lookup('router:main')

    routeNames = routerMain.get('router.recognizer.names')
    aboutRoute = routerMain.get('router').getHandler('about')
    console.log routeNames, aboutRoute
