`import Ember from "ember";`

ApplicationRoute = Ember.Route.extend

  setupController: ->
    @get('port').on('route:routeTree', @, @setRouteTree)
    @get('port').send('route:getRouteTree')

  deactivate: ->
    @get('port').off('route:routeTree')

  setRouteTree: (options) ->
    @set('controller.model', options.routeTree)

  actions:
    fetch: ->
      @get('port').send('route:getRouteTree')

`export default ApplicationRoute`