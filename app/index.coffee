require('lib/setup')
moment = require('moment')


Spine = require('spine')

class App extends Spine.Controller

  constructor: ->
    super
    @html require("views/app")()

  events:
    "click .start": 'startTimer'

  startTimer: ->
    @duration = moment.duration('00:00:15')
    @$('.timer').html(@duration.humanize())
    setInterval(@updateTimer, 1000)

  updateTimer: =>
    @duration.subtract('00:00:01')
    @$('.timer').html(@duration.humanize())

module.exports = App
