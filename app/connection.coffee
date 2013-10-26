Spine = require('spine')

class Server extends Spine.Module
  @include Spine.Events
  @include Spine.Log

  constructor: (@target) ->
    super
    @sock = new SockJS(@target)
    @init(@sock)

  send: (data) =>
    @sock.send JSON.stringify(data)

  init: (sock) =>
    sock.onopen = (conn) =>
      hello =
        msg: 'join'
        room: '12',
        name: 'leTimer'
      @send hello
        

      @trigger 'open',
        connection: conn
        socket: @sock

    sock.onmessage = (e) =>
      @trigger 'message',
        event: e
        data: JSON.parse(e.data)
        socket: @sock

    sock.onclose = (e) =>
      @trigger 'close',
        event: e
        socket: @sock


module.exports = Server