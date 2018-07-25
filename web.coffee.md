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
