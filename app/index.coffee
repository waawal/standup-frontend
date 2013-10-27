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
    @time = null
    @duration = null

    @connection = new Connection('https://standup-backend.herokuapp.com/sock')
    @connection.on 'message', (msg) => @process(msg)
    @controls.on 'call', () => @connection.send
      msg: 'call'
    @controls.on 'start', () => @connection.send
      msg: 'start'
    @controls.on 'stop', () => @connection.send
      msg: 'stop'
    @controls.on 'hangup', () => @connection.send
      msg: 'hangup'

  process: (msg) =>
    msg = msg.data
    if msg.msg is 'set'
      for key, val of msg
        @clock.trigger key, val if @[key] isnt val
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
