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

  router: computed( ->
    @get('application.__container__').lookup('router:main')
  ).property('application')

  routeTree: computed(->
    routeNames = @get('router.router.recognizer.names')
    routeTree = {}

    for routeName of routeNames
      if !routeNames.hasOwnProperty(routeName)
        continue
      route = routeNames[routeName]
      buildSubTree.call @, routeTree, route

    arrayizeChildren(children: routeTree).children[0]
  ).property('router')

  messages:
    getRouteTree: ->
      routeTree = @get('routeTree')
      console.log 'RouteTree sent', routeTree
      @sendMessage('routeTree', { routeTree: routeTree })

  sendTree: ->
    routeTree = @get('routeTree')
    @sendMessage 'routeTree', tree: routeTree

  getClassName: (name, type) ->
    container = @get('application.__container__')
    resolver = container.resolver
    if !resolver
      resolver = @get('application.registry.resolver')

    # TODO emberCliConfig
    prefix = @get('emberCliConfig.modulePrefix')
    podPrefix = @get('emberCliConfig.podModulePrefix')
    usePodsByDefault = @get('emberCliConfig.usePodsByDefault')

    className = undefined

    if prefix or podPrefix
      # Uses modules
      name = dasherize(name)
      className = resolver.describe(type + ':' + name)
      if className
        # Module exists and found
        className = className.replace(new RegExp('^/?(' + prefix + '|' + podPrefix + ')/' + type + 's/'), '')
      else
        # Module does not exist
        if usePodsByDefault
          # we don't include the prefix since it's redundant
          # and not part of the file path.
          # (podPrefix - prefix) is part of the file path.
          currentPrefix = ''
          if podPrefix
            currentPrefix = podPrefix.replace(new RegExp('^/?' + prefix + '/?'), '')
          className = currentPrefix + '/' + name + '/' + type
        else
          className = name.replace(/\./g, '/')
      className = className.replace(/\./g, '/')
    else
      # No modules
      if type != 'template'
        className = classify(name.replace(/\./g, '_') + '_' + type)
      else
        className = name.replace(/\./g, '/')
    className

buildSubTree = (routeTree, route) ->
  handlers = route.handlers
  container = @get('application.__container__')
  subTree = routeTree
  i = 0

  while i < handlers.length
    item = handlers[i]
    handler = item.handler
    if subTree[handler] == undefined
      routeClassName = @getClassName(handler, 'route')
      routeHandler = container.lookup('router:main').router.getHandler(handler)
      controllerName = routeHandler.get('controllerName') or routeHandler.get('routeName')
      controllerFactory = container.lookupFactory('controller:' + controllerName)
      controllerClassName = @getClassName(controllerName, 'controller')
      templateName = @getClassName(handler, 'template')

      subTree[handler] = value:
        name: handler
        routeHandler:
          className: routeClassName
          name: handler
        controller:
          className: controllerClassName
          name: controllerName
          exists: if controllerFactory then true else false
        template: name: templateName

      if i == handlers.length - 1
        # it is a route, get url
        subTree[handler].value.url = getURL(container, route.segments)
        subTree[handler].value.type = 'route'
      else
        # it is a resource, set children object
        subTree[handler].children = {}
        subTree[handler].value.type = 'resource'
    subTree = subTree[handler].children
    i++

arrayizeChildren = (routeTree) ->
  obj = value: routeTree.value
  if routeTree.children
    childrenArray = []
    for i of routeTree.children
      route = routeTree.children[i]
      childrenArray.push arrayizeChildren(route)
    obj.children = childrenArray
  obj

getURL = (container, segments) ->
  locationImplementation = container.lookup('router:main').location
  url = []
  i = 0
  while i < segments.length
    name = null
    try
      name = segments[i].generate()
    catch e
      # is dynamic
      name = ':' + segments[i].name
    if name
      url.push name
    i++
  url = url.join('/')
  if url.match(/_unused_dummy_/)
    url = ''
  else
    url = '/' + url
    url = locationImplementation.formatURL(url)
  url