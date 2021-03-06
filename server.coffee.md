    call_server = require 'useful-wind/call_server'

    run = (cfg) ->

      server = null

The configuration should contain a list of modules used to serve data and process calls.
The modules are listed in the `cfg.use` field.

Each module may export multiple functions described below; these functions are generally called with a context containing `@cfg`.
Functions of the same name are called in the order their are listed in the module; progress to the next step is only achieved once all functions have returned or (if they return a Promise) all Promises have completed (in the order they were returned).

- `@server_pre` functions are called before any others during server startup;

      errors = await serialize cfg, 'server_pre'
      if errors > 0
        throw new Error "server_pre had #{errors} errors"

      server = new call_server cfg
      cfg.server = server

- `@init` functions are called by `server.listen` (in useful-wind).
  These are guaranteed to have a `@router` object (in useful-wind).
  * cfg.port (integer) port number for the thinkable-ducks server (which handles outbound socket events from FreeSwitch)

      await server.listen cfg.port

- `@web` functions are Zappa fragments (same as regular zappajs `@include` fragments) to handle web requests.

      await (require './web') cfg

      await (require './munin') cfg

- `@server_post` functions are called at the end of server initialization.

      errors = await serialize cfg, 'server_post'
      if errors > 0
        throw new Error "server_post had #{errors} errors"
      server

- `@include` functions are used by the useful-wind router to handle individual calls. Their context is more complex since it contains specific details about a call.

- `@end` functions are called by `server.stop` (in useful-wind).

    module.exports = run
    serialize = require 'useful-wind-serialize'
