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
    "click .duration": "durationHandler"
    "click .call": "callHandler"
    "click .hangup": "hangupHandler"
  constructor: ->
    super
    @html require("views/controls")()

  startHandler: (e) =>
    e.preventDefault()
  stopHandler: (e) =>
    e.preventDefault()
  durationHandler: (e) =>
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
