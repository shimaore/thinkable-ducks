Web Services
============

    Zappa = require 'zappajs'
    sup = require './supervisor'
    pkg = require './package.json'
    Promise = require 'bluebird'

    module.exports = (cfg) ->
      return unless options.web?

      web = Zappa.run options.web, ->

CallServer statistics
---------------------

        need_statistics = @wrap ->
          unless cfg.statistics?
            @res.status(404).json error:'No statistics'
            @res.end()
            return

        @get '/statistics/:key', need_statistics, ->
          precision = @query.precision ? 7
          @res.type 'json'
          value = cfg.statistics.get @params.key
          if value?
            @send value.toJSON()
          else
            @res.status(404).json error:'No such key', key:@params.key

        @get '/statistics', need_statistics, ->
          precision = @query.precision ? 7
          @res.type 'json'
          @send cfg.statistics.toJSON precision

Generic statistics
------------------

        @get '/', ->
          @json
            ok:true
            package: pkg.name
            version: pkg.version
            uptime: process.uptime()
            memory: process.memoryUsage()

Supervisor info
---------------

        @get '/supervisor', ->
          supervisor = sup cfg
          res = {}
          supervisor.getSupervisorVersionAsync()
          .then (version) ->
            res.version = version
            supervisor.getStateAsync()
          .then (state) ->
            res.state = state
            supervisor.getAllProcessInfoAsync()
          .then (processes) ->
            res.processes = processes
          .then =>
            @json res
          .catch (error) =>
            @res.status(500).json error:error.toString()
