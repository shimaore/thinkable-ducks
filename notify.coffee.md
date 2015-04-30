Socket.IO client that maps `statistics` (that is, CaringBand-as-EventEmitter) messages to Socket.io messages.

    module.exports = (cfg) ->
      return unless cfg.notify? and cfg.statistics?

      socket = io cfg.notify

Standard events: `add`, `call`, `report`

      cfg.statistics.on 'add', (data) ->
        socket.emit 'statistics:add',
          host: cfg.host
          key: data.key
          value: data.value.toJSON()
      cfg.statistics.on 'call', (data) ->
        socket.emit 'call',
          host: cfg.host
          data: data
      cfg.statistics.on 'report', (data) ->
        socket.emit 'report',
          host: cfg.host
          data: data

Optionally let each module define its own events

      if cfg.use?
        for m in cfg.use when m.notify?
          do (m) ->
            ctx = {cfg,socket}
            m.notify.call ctx, ctx

    io = require 'socket.io-client'
    pkg = require './package.json'
