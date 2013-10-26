Spine = require('spine')

class Controls extends Spine.Controller
  className: 'aside col-md-4'
  constructor: ->
    super
    @html require("views/controls")()
    
module.exports = Controls