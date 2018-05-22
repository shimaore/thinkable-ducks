    run = (cfg) ->

      await serialize cfg, 'config'

Generate the configuration for FreeSwitch
=========================================

      debug 'Building FreeSwitch configuration'
      unless cfg.server_only is true
        xml = await cfg.freeswitch? cfg
        await fs.mkdirAsync '/data/conf'
        await fs
          .writeFileAsync '/data/conf/freeswitch.xml', xml, 'utf-8'
          .catch (error) ->
            debug.dev "Unable to create FreeeSwitch configuration: #{error}"
            throw error

    module.exports = run
    Bluebird = require 'bluebird'
    fs = Bluebird.promisifyAll require 'fs'
    serialize = require 'useful-wind-serialize'
    debug = (require 'debug') 'thinkable-ducks:config'
