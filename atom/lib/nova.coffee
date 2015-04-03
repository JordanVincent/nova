NovaView = require './nova-view'
{CompositeDisposable} = require 'atom'

module.exports = Nova =
  novaView: null
  rightPanel: null
  subscriptions: null

  activate: (state) ->
    console.log('activated')
    @novaView = new NovaView(state.novaViewState)
    @rightPanel = atom.workspace.addRightPanel(item: @novaView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'nova:toggle': => @toggle()

  deactivate: ->
    @rightPanel.destroy()
    @subscriptions.dispose()
    @novaView.destroy()

  serialize: ->
    novaViewState: @novaView.serialize()

  toggle: ->
    console.log 'Nova was toggled!'

    if @rightPanel.isVisible()
      @rightPanel.hide()
    else
      @rightPanel.show()
