require('lib/setup')
moment = require('moment/moment')


Spine = require('spine')

class App extends Spine.Controller

  constructor: ->
    super
    @html require("views/app")()
    @$(".start").click => @startTimer

  startTimer: ->
    @duration = moment.duation(15, 'minutes')
    @$('.timer').html(@duration)
    setInterval(@updateTimer, 1000)

  updateTimer: =>
    @duration
    @$('.timer').html()

module.exports = App
