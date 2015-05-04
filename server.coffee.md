    call_server = require 'useful-wind/call_server'

    run = (cfg) ->

      server = null

      serialize cfg, 'server_pre'
      .then ->

        server = new call_server cfg
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
    serialize = require './serialize'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:server"
