Socket.IO client that maps `statistics` (that is, CaringBand-as-EventEmitter) messages to Socket.io messages.

    module.exports = (cfg,server) ->
      return unless cfg.notify? and cfg.statistics?

      socket = io cfg.notify
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

    io = require 'socket.io-client'
    pkg = require './package.json'
