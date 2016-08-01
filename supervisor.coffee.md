Async Supervisor access
-----------------------

    supervisord = require 'supervisord'
    Promise = require 'bluebird'
    assert = require 'assert'

    module.exports = sup = (cfg) ->
      supervisor = process.env.SUPERVISOR
      assert supervisor?, 'Missing SUPERVISOR environment variable'
      Promise.promisifyAll supervisord.connect supervisor
