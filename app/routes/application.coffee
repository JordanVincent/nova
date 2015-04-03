`import Ember from "ember";`

ApplicationRoute = Ember.Route.extend
  model: ->
    ['about', 'inspiration', 'projects']

`export default ApplicationRoute`