    run = (cfg) ->
      mode = process.env.MODE

      switch mode
        when 'config'
          (require './config') cfg
        when 'server'
          (require './server') cfg

    module.exports = run
