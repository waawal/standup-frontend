Spine = require('spine')

moment = require('moment')

class Clock extends Spine.Controller
  className: 'main col-md-8'
  elements:
    ".timer": "timer"
  #events:
  #  "click .start": 'startTimer'

  constructor: ->
    super
    @duration = 15 * 60
    @time = 0
    @render()
    
    @on "state", (state) =>
      if state is "running"
        @intervalId = setInterval @updateTimer, 1000
      else
        if @intervalId?
          clearInterval(@intervalId)
    @on "duration", (duration) =>
      @duration = duration
    @on "time", (time) =>
      @time = time
    #  @startTimer()

  updateTimer: =>
    progress = moment.duration(@duration, 'seconds').subtract(@time, 'seconds')
    @timer.html progress.asSeconds()

  render: =>
    @html require("views/clock") @duration

module.exports = Clock