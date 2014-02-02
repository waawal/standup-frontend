require('lib/setup')


Spine = require('spine')
Clock = require('controllers/clock')
Controls = require('controllers/controls')

Connection = require('connection')

class App extends Spine.Controller
  #className: 'container'
  
  constructor: ->
    super

    @clock = new Clock()
    @controls = new Controls()
    @append @clock, @controls

    @state = null
    @duration = @clock.defaultDuration
    @time = 0  # milliseconds, counts up to duration

    @connection = new Connection('https://standup-backend.herokuapp.com/sock')
    @connection.on 'message', (msg) => @process(msg)
    @controls.on 'call', =>
      @log 'sending call'
      @connection.send
        msg: 'call'
    @controls.on 'hangup', =>
      @log 'sending hangup'
      @connection.send
        msg: 'hangup'
    @controls.on 'start', =>
      @connection.send
        msg: 'start'
      @clock.trigger 'state', 'running'
      @connection.send
        msg: 'set'
        state: 'running'
    @controls.on 'stop', =>
      @connection.send
        msg: 'stop'
      @clock.trigger 'state', 'paused'
      @connection.send
        msg: 'set'
        state: 'paused'
    @controls.on 'duration', duration, =>
      @log duration
      @connection.send
        msg: 'set'
        duration: duration * 60000  # convert minutes to milliseconds

  process: (msg) =>
    msg = msg.data
    if msg.msg is 'set'
      for key, val of msg
        if @[key] isnt val
          @clock.trigger key, val
          @[key] = val
    if msg.msg is 'join'
      @connection.send
        msg: 'welcome'
        name: 'leCounter'
      @connection.send
        msg: 'set'
        state: @state
        time: @time
        duration: @duration
    if msg.msg is 'welcome'
      @log msg

module.exports = App
