require('lib/setup')


Spine = require('spine')
Clock = require('controllers/clock')
Controls = require('controllers/controls')

Connection = require('connection')

class App extends Spine.Controller
  #className: 'container'
  
  constructor: ->
    super

    @connection = new Connection('https://standup-backend.herokuapp.com/sock')

    @clock = new Clock(@connection)
    @controls = new Controls()
    @append @clock, @controls

    @state = 'paused'

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
      @state = 'running'
      @clock.trigger 'state', @state
      @connection.send
        msg: 'set'
        state: @state
    @controls.on 'stop', =>
      @state = 'paused'
      @clock.trigger 'state', @state
      @connection.send
        msg: 'set'
        state: @state
    @controls.on 'duration', duration, =>
      @connection.send
        msg: 'set'
        duration: duration

  process: (msg) =>
    msg = msg.data
    if msg.msg is 'set'
      for key, val of msg
        if @[key] isnt val
          @clock.trigger key, val
          @[key] = val
      @clock.renderTimer()
    if msg.msg is 'join'
      @connection.send
        msg: 'welcome'
        name: 'leCounter'
      @connection.send
        msg: 'set'
        state: @state
        time: @clock.time
        duration: @clock.duration
    if msg.msg is 'welcome'
      @log msg

module.exports = App
