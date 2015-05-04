Async Supervisor access
-----------------------

    supervisord = require 'supervisord'
    Promise = require 'bluebird'
    assert = require 'assert'

    module.exports = sup = (cfg) ->
      assert process.env.SUPERVISOR?, 'Missing SUPERVISOR environment variable'
      supervisor = process.env.SUPERVISOR
      return unless supervisor?
      Promise.promisifyAll supervisord.connect supervisor
