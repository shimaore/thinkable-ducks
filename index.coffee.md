    run = (cfg) ->
      assert process.env.MODE?, 'Missing MODE environment variable'
      mode = process.env.MODE

      switch mode
        when 'config'
          (require './config') cfg
        when 'server'
          (require './server') cfg

    assert = require 'assert'
    module.exports = run
