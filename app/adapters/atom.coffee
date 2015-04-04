`import BasicAdapter from "./basic";`

AtomAdapter = BasicAdapter.extend
  name: 'atom'

  emitter: ( ->
    atom.emitter
  ).property()

  init: ->
    disposable = @get('emitter').on 'debugMessage', (message) =>
      @_messageReceived(message)
    @set('disposable', disposable)

  willDestroy: ->
    @_super()
    @get('disposable').dispose()

  sendMessage: (options) ->
    options = options or {}
    @get('emitter').emit 'emberMessage', options

`export default AtomAdapter;`