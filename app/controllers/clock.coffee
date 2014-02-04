Spine = require('spine')

class Clock extends Spine.Controller
  className: 'main col-md-8'
  elements:
    ".timer": "timer"

  constructor: (@connection) ->
    super

    @precision = 1000  # milliseconds

    @second = 1000  # milliseconds
    @minute = 60 * @second
    @hour = 60 * @minute

    @syncEvery = 10 * @second
    @syncTimestamp = 0

    @defaultDuration = 15 * @minute

    @state = 'paused'
    @duration = @defaultDuration
    @time = 0  # milliseconds, counts up to duration
    @lastTimestamp = null

    @render()

    @on "state", (state) =>
      @state = state
      if state is "paused" and @lastTimestamp != null
        @lastTimestamp = null
        clearInterval(@intervalId)
      if state is "running" and @lastTimestamp == null
        @lastTimestamp = new Date().getTime()
        @intervalId = setInterval @updateTimer, @precision
        
    @on "duration", (duration) =>
      @duration = duration

    @on "time", (time) =>
      if @state is "running"
        # Synchronize time - only forward.
        if time > @time then @time = time
      if @state is "paused"
        # Reset time to exact value.
        @time = time

  updateTimer: =>
    @newTimestamp = new Date().getTime()
    timeDelta = @newTimestamp - @lastTimestamp
    @lastTimestamp = @newTimestamp

    @time += timeDelta
    @renderTimer()

    @syncTimestamp += timeDelta
    if @syncTimestamp > @syncEvery
      @syncTimestamp = 0
      @connection.send
        msg: 'set'
        time: @time

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
