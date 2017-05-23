Socket.IO client that maps `statistics` (that is, CaringBand-as-EventEmitter) messages to Socket.io messages.
This is meant to be used in conjunction with (e.g.) the `spicy-action` message forwarder.

    seem = require 'seem'

    module.exports = seem (cfg) ->
      unless cfg.notify?
        debug 'Missing cfg.notify, not starting Socket.IO'
        return

      socket = io cfg.notify

Let each module define its own events

      ctx = {cfg,socket}
      yield serialize.modules cfg.use, ctx, 'notify'

    io = require 'socket.io-client'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:notify"
    serialize = require 'useful-wind-serialize'
