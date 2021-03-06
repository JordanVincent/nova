{$} = require 'atom'

module.exports =
class NovaView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('nova')

    # Dev Ember App
    iframe = document.createElement('iframe')
    iframe.setAttribute("src", "http://localhost:4200/")
    @element.appendChild(iframe)

    @loadEmberNova()

    $(iframe).load =>
      contentWindow = $(@element).find('iframe').prop('contentWindow')

      EmberDebug = require './ember-debug/main'
      emberDebug = EmberDebug.create({appWindow: contentWindow})
      emberDebug.start()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  loadEmberNova: ->
    emberAppRoot = document.createElement('div')
    emberAppRoot.id = 'emberNova'
    @element.appendChild(emberAppRoot)

    metaTag = document.createElement('meta')
    metaTag.name = "nova/config/environment";
    metaTag.content = "%7B%22modulePrefix%22%3A%22nova%22%2C%22environment%22%3A%22development%22%2C%22baseURL%22%3A%22/%22%2C%22locationType%22%3A%22none%22%2C%22EmberENV%22%3A%7B%22FEATURES%22%3A%7B%7D%7D%2C%22APP%22%3A%7B%22name%22%3A%22nova%22%2C%22version%22%3A%220.0.0.a14f089b%22%7D%2C%22contentSecurityPolicyHeader%22%3A%22Content-Security-Policy-Report-Only%22%2C%22contentSecurityPolicy%22%3A%7B%22default-src%22%3A%22%27none%27%22%2C%22script-src%22%3A%22%27self%27%20%27unsafe-eval%27%22%2C%22font-src%22%3A%22%27self%27%22%2C%22connect-src%22%3A%22%27self%27%22%2C%22img-src%22%3A%22%27self%27%22%2C%22style-src%22%3A%22%27self%27%22%2C%22media-src%22%3A%22%27self%27%22%7D%2C%22exportApplicationGlobal%22%3Atrue%7D";
    document.getElementsByTagName('head')[0].appendChild(metaTag)

    novaDirectoryPath = '../../../../../../../home/jo/projects/nova'
    @loadScript "#{novaDirectoryPath}/bower_components/jquery/dist/jquery.js", =>
      @loadScript "#{novaDirectoryPath}/dist/assets/vendor.js", =>
        @loadScript "#{novaDirectoryPath}/dist/assets/nova.js", =>
          @loadStyle "#{novaDirectoryPath}/dist/assets/vendor.css", =>
            @loadStyle "#{novaDirectoryPath}/dist/assets/nova.css"


  loadScript: (src, callback) ->
    s = document.createElement('script')
    s.type = 'text/javascript'
    s.src = src

    @loadFile(s, callback)

  loadStyle: (src, callback) ->
    s = document.createElement('link')
    s.type = 'text/css'
    s.href = src
    s.rel = 'stylesheet'

    @loadFile(s, callback)

  loadFile: (element, callback) ->
    r = false
    element.onload =
    element.onreadystatechange = ->
      #console.log( this.readyState ); //uncomment this line to see which ready states are called.
      if !r and (!@readyState or @readyState == 'complete')
        r = true
        if callback
          callback()

    t = document.getElementsByTagName('body')[0]
    t.appendChild element

