    run = (cfg) ->

      supervisor = sup cfg

      await serialize cfg, 'config'

Generate the configuration for FreeSwitch
=========================================

      debug 'Building FreeSwitch configuration'
      unless cfg.server_only is true
        xml = await cfg.freeswitch? cfg
        await fs
          .writeFileAsync '/data/conf/freeswitch.xml', xml, 'utf-8'
          .catch (error) ->
            debug.dev "Unable to create FreeeSwitch configuration: #{error}"
            throw error

Start the processes
===================

      yield supervisor.startProcessAsync 'server'
      debug 'Started server'

      unless cfg.server_only is true
        yield supervisor.startProcessAsync 'freeswitch'
        debug 'Started FreeSwitch'

    module.exports = run
    Bluebird = require 'bluebird'
    fs = Bluebird.promisifyAll require 'fs'
    sup = require './supervisor'
    serialize = require 'useful-wind-serialize'
    debug = (require 'debug') 'thinkable-ducks:config'
