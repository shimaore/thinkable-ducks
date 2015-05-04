    run = (cfg) ->

      if cfg.use?
        for m in cfg.use when m.config?
          do (m) ->
            ctx = {cfg}
            debug "Calling middleware #{m.name}.config()"
            m.config.call ctx, ctx

Generate the configuration for FreeSwitch
=========================================

      Promise.resolve()
      .then ->
        debug 'Building FreeSwitch configuration'
        unless cfg.server_only is true
          cfg.freeswitch? cfg
      .then (xml) ->
        unless cfg.server_only is true
          fs.writeFileAsync process.env.FSCONF, xml, 'utf-8'
      .catch (error) ->
        debug "Unable to create FreeeSwitch configuration: #{error}"
        throw error

Start the processes
===================

      .then ->
        supervisor = sup cfg
        supervisor.startProcessAsync 'call_server'
      .then ->
        debug 'Started call_server'
      .then ->
        unless cfg.server_only is true
          supervisor.startProcessAsync 'freeswitch'
      .then ->
        unless cfg.server_only is true
          debug 'Started FreeSwitch'


    module.exports = run
    Promise = require 'bluebird'
    fs = Promise.promisifyAll require 'fs'
    sup = require './supervisor'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:config"
