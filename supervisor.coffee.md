Async Supervisor access
-----------------------

    supervisord = require 'supervisord'
    Promise = require 'bluebird'

    module.exports = sup = (cfg) ->
      supervisor = process.env.SUPERVISOR
      return unless supervisor?
      Promise.promisifyAll supervisord.connect supervisor
