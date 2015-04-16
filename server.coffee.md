    call_server = require 'useful-wind/call_server'
    CaringBand = require 'caring-band'
    pkg = require './package.json'

    run = (cfg) ->
      server = new call_server cfg
      cfg.server = server
      cfg.statistics = new CaringBand()
      (require './web') cfg
      (require './notify') cfg

      server

    module.exports = run
    if module is require.main
      cfg = require process.env.CONFIG
      run cfg
