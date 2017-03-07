    call_server = require 'useful-wind/call_server'
    CaringBand = require 'caring-band'

    seem = require 'seem'

    run = seem (cfg) ->

      server = null

The configuration should contain a list of modules used to serve data and process calls.
The modules are listed in the `cfg.use` field.

Each module may export multiple functions described below; these functions are generally called with a context containing `@cfg`.
Functions of the same name are called in the order their are listed in the module; progress to the next step is only achieved once all functions have returned or (if they return a Promise) all Promises have completed (in the order they were returned).

- `@server_pre` functions are called before any others during server startup; they may initialize a `cfg.statistics` object.

      yield serialize cfg, 'server_pre'

  If no `@server_pre` function assign a `statistics` object, one is provided.

      cfg.statistics ?= new CaringBand()

      server = new call_server cfg
      cfg.server = server

- `@init` functions are called by `server.listen` (in useful-wind).
  These are guaranteed to have a `@statistics` object (above) and a `@router` object (in useful-wind).
  * cfg.port (integer) port number for the thinkable-ducks server (which handles outbound socket events from FreeSwitch)

      yield server.listen cfg.port

- `@web` functions are Zappa fragments (same as regular zappajs `@include` fragments) to handle web requests.

      (require './web') cfg

- `@notify` functions are socket.io-client handlers; they receive `cfg`, `socket`.

      (require './notify') cfg

      (require './munin') cfg

- `@server_post` functions are called at the end of server initialization.

      yield serialize cfg, 'server_post'
      server

- `@include` functions are used by the useful-wind router to handle individual calls. Their context is more complex since it contains specific details about a call.

    module.exports = run
    serialize = require 'useful-wind-serialize'
    pkg = require './package.json'
    debug = (require 'debug') "#{pkg.name}:server"
