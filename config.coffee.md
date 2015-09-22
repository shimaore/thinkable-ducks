    run = (cfg) ->

      supervisor = sup cfg

      serialize cfg, 'config'

Generate the configuration for FreeSwitch
=========================================

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
        supervisor.startProcessAsync 'server'
      .then ->
        debug 'Started server'
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
    serialize = require 'useful-wind-serialize'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:config"
