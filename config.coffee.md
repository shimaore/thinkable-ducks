    run = (cfg) ->

      errors = await serialize cfg, 'config'
      if errors > 0
        throw new Error "config had #{errors} errors"

Generate the configuration for FreeSwitch
=========================================

      debug 'Building FreeSwitch configuration'
      unless cfg.server_only is true
        xml = await cfg.freeswitch? cfg
        await fs.mkdirAsync '/dev/shm/freeswitch'
        await fs
          .writeFileAsync '/dev/shm/freeswitch/freeswitch.xml', xml, 'utf-8'
          .catch (error) ->
            debug.dev "Unable to create FreeeSwitch configuration: #{error}"
            throw error

    module.exports = run
    Bluebird = require 'bluebird'
    fs = Bluebird.promisifyAll require 'fs'
    serialize = require 'useful-wind-serialize'
    debug = (require 'debug') 'thinkable-ducks:config'
