# requirejs = require('requirejs')
# requirejs.config
#   nodeRequire: require

NovaView = require './nova-view'
{CompositeDisposable} = require 'atom'


# window.jQuery = require 'jquery'
# aa = require '/home/jo/perso/jordan-vincent.com/dist/assets/vendor-64912f0a114897fe2731cde4c34ffcc9.js'
# ab = require '/home/jo/perso/jordan-vincent.com/dist/assets/jordan-vincent-bbb10b32ad5050e39175c4ff7af42510.js'

# fs = require('fs')
# filedata = fs.readFileSync('/home/jo/perso/jordan-vincent.com/dist/assets/vendor.js','utf8')
# {allowUnsafeEval} = require 'loophole'
#
# allowUnsafeEval ->
#   eval(filedata)

module.exports = Nova =
  novaView: null
  rightPanel: null
  subscriptions: null

  activate: (state) ->
    # console.log aa, ab
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
