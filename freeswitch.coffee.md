    module.exports = ->

Start the processes
===================

      s = child_process.spawn '/opt/freeswitch/bin/freeswitch',
        [ '-c', '-nonat', '-nonatmap', '-conf', '/dev/shm/freeswitch', '-log', '/dev/shm/freeswitch', '-db', '/dev/shm/freeswitch', '-temp', '/dev/shm/freeswitch' ],
        stdio: ['ignore',process.stdout,process.stderr]

      s.on 'close', (code,signal) ->
        debug.dev "Process closed with code #{code}, signal #{signal}"
        process.exit code

      s.on 'error', (error) ->
        debug.dev "Process exited with error #{error}"
        process.exit 1

      s.on 'exit', (code,signal) ->
        debug.dev "Process exited with code #{code}, signal #{signal}"
        process.exit code
        
      process.on 'exit', -> s.kill()

      s

    child_process = require 'child_process'
    debug = (require 'tangible') 'thinkable-ducks:freeswitch'
