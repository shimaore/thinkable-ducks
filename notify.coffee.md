Socket.IO client that maps `statistics` (that is, CaringBand-as-EventEmitter) messages to Socket.io messages.
This is meant to be used in conjunction with (e.g.) the `spicy-action` message forwarder.

    module.exports = (cfg) ->
      unless cfg.notify?
        debug 'Missing cfg.notify, not starting Socket.IO'
        return

      socket = io cfg.notify

Standard events: `add`.

      cfg.statistics?.on 'add', (data) ->
        socket.emit 'statistics:add',
          host: cfg.host
          key: data.key
          value: data.value.toJSON()

Optionally let each module define its own events

      if cfg.use?
        for m in cfg.use when m.notify?
          do (m) ->
            ctx = {cfg,socket}
            m.notify.call ctx, ctx

    io = require 'socket.io-client'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:notify"
