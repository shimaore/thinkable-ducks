    module.exports = ->

Start the processes
===================

      await fs.mkdirAsync '/data/log'

      s = child_process.spawn '/opt/freeswitch/bin/freeswitch',
        [ '-c', '-nonat', '-nonatmap', '-conf', '/data/conf', '-log', '/data/log', '-db', '/dev/shm/freeswitch', '-temp', '/data/log' ],
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

      s

    child_process = require 'child_process'
    Bluebird = require 'bluebird'
    fs = Bluebird.promisifyAll require 'fs'
    debug = (require 'tangible') 'thinkable-ducks:freeswitch'
