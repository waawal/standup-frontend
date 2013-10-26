Spine = require('spine')

class Server extends Spine.Module
  @extend Spine.Events
  @include Spine.Log

  constructor: (target) ->
    super
    @sock = new SockJS(target)
    @init()

  send: (data) =>
    @sock.send data

  init: =>
    @sock.onopen = (conn) ->
      @trigger 'open',
        connection: conn
        socket: @socket

    @sock.onmessage = (e) ->
      @trigger 'message',
        event: e
        data: data

    @sock.onclose = (e) ->
      @trigger 'close',
        event: e


module.exports = Server