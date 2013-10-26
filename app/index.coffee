require('lib/setup')
moment = require('moment')

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
        state: @state
        time: @time
        duration: @duration
    if msg.msg is 'welcome'
      @log msg

module.exports = App
