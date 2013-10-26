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
    @duration = moment.duration(15, 'seconds')
    conslo
    @$('.timer').html(@duration.humanize())
    setInterval(@updateTimer, 1000)

  updateTimer: =>
    @duration.subtract(1, 's')
    @$('.timer').html(@duration.humanize())

module.exports = App
