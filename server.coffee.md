    call_server = require 'useful-wind/call_server'
    CaringBand = require 'caring-band'

    run = (cfg) ->

      server = null

      serialize cfg, 'server_pre'
      .then ->

If `server_pre` did not provide a `statistics` object, provide a default one.

        cfg.statistics ?= new CaringBand()

        server = new call_server cfg

`server.listen` will call the `@init` functions.

        server.listen cfg.port
        cfg.server = server

        (require './web') cfg
        (require './notify') cfg

        null
      .then ->
        serialize cfg, 'server_post'
      .then ->
        server

    module.exports = run
    serialize = require 'useful-wind/serialize'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:server"
