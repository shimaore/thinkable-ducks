    module.exports = main = ->
      cfg = do require './index'
      ducks = require 'thinkable-ducks/server'
      ducks cfg

    if require.main is module
      debug = (require 'debug') "#{(require './package').name}:server"
      main().catch (error) -> debug "Startup failed: #{error}"
