BasicAdapter = require "./basic"
Ember = window.Ember

module.exports = BasicAdapter.extend

  emitter: ( ->
    atom.emitter
  ).property()

  sendMessage: (options) ->
    options = options or {}
    @get('emitter').emit 'debugMessage', options

  init: ->
    disposable = @get('emitter').on 'emberMessage', (message) =>
      Ember.run =>
        @_messageReceived(message)
    @set('disposable', disposable)

  willDestroy: ->
    @_super()
    @get('disposable').dispose()
