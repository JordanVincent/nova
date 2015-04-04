`import Ember from 'ember';`
`import Resolver from 'ember/resolver';`
`import loadInitializers from 'ember/load-initializers';`
`import config from './config/environment';`
`import Port from "./port";`
`import Adapter from "./adapters/atom";`

Ember.MODEL_FACTORY_INJECTIONS = true

App = Ember.Application.extend
  modulePrefix: config.modulePrefix
  podModulePrefix: config.podModulePrefix
  Resolver: Resolver

App.initializer
  name: 'app-init'

  initialize: (container, app) ->
    # inject adapter
    container.register('adapter:main', Adapter)
    container.typeInjection('port', 'adapter', 'adapter:main')

    # inject port
    container.register('port:main', Port)
    container.typeInjection('controller', 'port', 'port:main')
    container.typeInjection('route', 'port', 'port:main')

loadInitializers(App, config.modulePrefix)

`export default App;`
