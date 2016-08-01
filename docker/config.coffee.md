    module.exports = main = ->
      cfg = do require './index'
      ducks = require 'thinkable-ducks/config'
      ducks cfg

    if require.main is module
      debug = (require 'debug') "#{(require './package').name}:config"
      main().catch (error) -> debug "Startup failed: #{error}"
