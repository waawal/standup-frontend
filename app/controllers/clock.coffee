Spine = require('spine')

class Clock extends Spine.Controller
  className: 'main col-md-8'
  elements:
    ".timer": "timer"
  #events:
  #  "click .start": 'startTimer'

  constructor: ->
    super
    @duration = moment.duration '00:00:15'
    @render()
    @startTimer()
    @on "state", (state) =>
      if state is "running"
        @log "Starting timer"
      else
        @log "stopping timer"
    @on "duration", (duration) =>
      @log "setting duration"
    @on "time", (time) =>
      @log "setting the time"
    #  @startTimer()
    

  startTimer: =>
    setInterval @updateTimer, 1000

  updateTimer: =>
    @duration.subtract '00:00:01'
    @timer.html @duration.asSeconds()

  render: =>
    @html require("views/clock") @duration

module.exports = Clock