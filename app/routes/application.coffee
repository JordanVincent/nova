`import Ember from "ember";`

ApplicationRoute = Ember.Route.extend

  setupController: ->
    @get('port').on('route:routes', @, @setRoutes)
    @get('port').send('route:getRoutes')

  deactivate: ->
    @get('port').off('route:routes')

  setRoutes: (options) ->
    console.log 'yay', options
    @set('controller.model', options.routes)

  actions:
    fetch: ->
      @get('port').send('route:getRoutes')

`export default ApplicationRoute`