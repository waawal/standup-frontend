Spine = require('spine')

class Clock extends Spine.Controller
  className: 'main col-md-8'
  elements:
    ".timer": "timer"

  constructor: ->
    super

    @precision = 1000  # milliseconds
    @second = 1000  # milliseconds
    @minute = 60 * @second
    @hour = 60 * @minute

    @defaultDuration = 15 * @minute
    @duration = @defaultDuration
    @time = 0  # milliseconds, counts up to duration

    @render()

    @on "state", (state) =>
      if @intervalId?
          clearInterval(@intervalId)
      if state is "running"
        @intervalId = setInterval @updateTimer, @precision
        
    @on "duration", (duration) =>
      @duration = duration

    @on "time", (time) =>
      @time = time

  updateTimer: =>
    @time = @time + @precision
    @renderTimer()

  renderTimer: =>
    counterMilliseconds = @duration - @time
    @timer.html @timeToString(counterMilliseconds)

  timeToString: (time) =>  # time in milliseconds
    pad2 = (n) =>
      if Math.abs(n) >= 10 then n else (if n < 0 then "-0" + -n else "0" + n)
    sign = if time < 0 then "-" else ""
    atime = Math.abs(time)
    hours = Math.floor(atime / @hour)
    minutes = Math.floor((atime % @hour) / @minute)
    seconds = Math.floor((atime % @minute) / @second)
    return sign + pad2(hours) + ':' + pad2(minutes) + ':' + pad2(seconds)

  render: =>
    @html require("views/clock") @duration

module.exports = Clock
