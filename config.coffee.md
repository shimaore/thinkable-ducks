    run = (cfg) ->

Generate the configuration for FreeSwitch
=========================================

      Promise.resolve() ->
        debug 'Building FreeSwitch configuration'
        if cfg.freeswitch?
          cfg.freeswitch cfg
      .then (xml) ->
        unless cfg.server_only is true
          fs.writeFileAsync './conf/freeswitch.xml', xml, 'utf-8'
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
    if module is require.main
      cfg = require process.env.CONFIG
      run cfg
