    run = (cfg) ->

      errors = await serialize cfg, 'config'
      if errors > 0
        throw new Error "config had #{errors} errors"

Generate the configuration for FreeSwitch
=========================================

      unless cfg.server_only is true
        debug 'Building FreeSwitch configuration'
        xml = await cfg.freeswitch? cfg
        await fs.mkdir '/dev/shm/freeswitch'
        await fs
          .writeFile '/dev/shm/freeswitch/freeswitch.xml', xml, 'utf-8'
          .catch (error) ->
            debug.dev "Unable to create FreeeSwitch configuration: #{error}"
            throw error

    module.exports = run
    Bluebird = require 'bluebird'
    fs = (require 'fs').promises
    serialize = require 'useful-wind-serialize'
    debug = (require 'debug') 'thinkable-ducks:config'
