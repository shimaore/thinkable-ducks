Web Services
============

    Zappa = require 'zappajs'
    pkg = require './package.json'
    serialize = require 'useful-wind-serialize'

    module.exports = (cfg) ->
      return unless cfg.web?

      cfg.versions ?= {}
      cfg.versions[pkg.name] = pkg.version

      web = Zappa.run cfg.web, ->

        @use morgan:'combined'

        @helper {cfg}
        @cfg = cfg

CallServer statistics
---------------------

        need_statistics = @wrap ->
          unless cfg.statistics?
            @res.status(404).json error:'No statistics'
            @res.end()
            return
          @next()

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
            uptime: process.uptime()
            memory: process.memoryUsage()
            versions: @cfg.versions

Modules web services
--------------------

        errors = await serialize.modules cfg.use, this, 'web'
        if errors > 0
          throw new Error "web had #{errors} errors"
        return
