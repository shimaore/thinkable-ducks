    call_server = require 'useful-wind/call_server'

    run = (cfg) ->
      if cfg.use?
        ctx = {cfg}
        for m in cfg.use when m.server_pre?
          do (m) ->
            debug "Calling middleware #{m.name}.server_pre()"
            m.server_pre.call ctx, ctx

      server = new call_server cfg
      server.listen cfg.port
      cfg.server = server

      (require './web') cfg
      (require './notify') cfg

      if cfg.use?
        ctx = {cfg,server}
        for m in cfg.use when m.server_post?
          do (m) ->
            debug "Calling middleware #{m.name}.server_post()"
            m.server_post.call ctx, ctx

      server

    module.exports = run
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:server"
