    seem = require 'seem'
    run = seem (cfg) ->

      supervisor = sup cfg

      yield serialize cfg, 'config'

Generate the configuration for FreeSwitch
=========================================

      debug 'Building FreeSwitch configuration'
      unless cfg.server_only is true
        xml = yield cfg.freeswitch? cfg
        yield fs
          .writeFileAsync process.env.FSCONF, xml, 'utf-8'
          .catch (error) ->
            debug "Unable to create FreeeSwitch configuration: #{error}"
            throw error

Start the processes
===================

      yield supervisor.startProcessAsync 'server'
      debug 'Started server'

      unless cfg.server_only is true
        yield supervisor.startProcessAsync 'freeswitch'
        debug 'Started FreeSwitch'

    module.exports = run
    Promise = require 'bluebird'
    fs = Promise.promisifyAll require 'fs'
    sup = require './supervisor'
    serialize = require 'useful-wind-serialize'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:config"

    if require.main is module
      main()
      .catch (error) ->
        debug "Startup failed: #{error}"
