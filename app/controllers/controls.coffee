Spine = require('spine')

class Controls extends Spine.Controller
  className: 'aside col-md-4'
  elements:
    ".start": "start"
    ".stop": "stop"
    ".duration": "duration"
  events: 
    "click .start": "startHandler"
    "click .stop": "stopHandler"
    "click .call": "callHandler"
    "click .hangup": "hangupHandler"
  constructor: ->
    super
    @html require("views/controls")()
    $(@duration).keyup =>
      @trigger 'duration', Number(@duration.val())
      e.preventDefault()

  startHandler: (e) =>
    @trigger 'start'
    e.preventDefault()
  stopHandler: (e) =>
    @trigger 'stop'
    e.preventDefault()
  callHandler: (e) =>
    @log 'callHandler'
    @trigger 'call'
    e.preventDefault()
  hangupHandler: (e) =>
    @log 'hangupHandler'
    @trigger 'hangup'
    e.preventDefault()

    
module.exports = Controls
