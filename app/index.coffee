require('lib/setup')


Spine = require('spine')

class App extends Spine.Controller
  constructor: ->
    super
    @html require("views/app")({version:Spine.version})

module.exports = App
