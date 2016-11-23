FreeSwitch controlled by Node.js middleware
===========================================

[`useful-wind`](https://github.com/shimaore/useful-wind) is a middleware framework for FreeSwitch.
This module extends `useful-wind` with web and notification services to support call-handling.
This module also provides a working [FreeSwitch image](https://registry.hub.docker.com/u/shimaore/thinkable-ducks/) as a Docker container under the name `shimaore/thinkable-ducks`.

Features
========

* Docker image with FreeSwitch and Node.js
* FreeSwitch calls are controlled by Node.js using the Event Socket
* Realtime statistical reporting via extendable web services
* Realtime notifications via extendable Socket.IO client

Processes
=========

Three processes are managed by a common supervisord instance:

* the `config` application is ran once at startup to provide configuration, especially to create the FreeSwitch XML configuration file;
* the `server` application provides the Event Socket handler, web services, etc.
* FreeSwitch.

Supervisord can be controlled using its HTTP interface.

`config`
--------

The `config` application will run any `config` middleware function.

It will then create a FreeSwitch XML configuration file by rendering the `freeswitch` template in the configuration object. The templace could be an [`acoustic-line`](https://github.com/shimaore/acoustic-line) template, or any function that will return a valid FreeSwitch XML configuration file.

Finally it will start the `server` application, and FreeSwitch itself.

Note: if the configuration contains a `server_only` flag, no FreeSwitch configuration is created, and FreeSwitch is not started.

`server`
--------

The `server` application with first run any `server_pre` middleware function. This is used for example in the [`docker.tough-rate` server module](https://github.com/shimaore/docker.tough-rate/blob/master/middleware/server.coffee.md) to initialize database access, etc.

The application will then start the Event Socket server (`useful-wind`), the `web` service, and the `notify` service.

Finally it will run any `server_post` middleware function.

### `web`

The web service provides by default:

* `GET /`
* `GET /statistics`
* `GET /statistics/:key`
* `GET /supervisor`

It may be extended by `web` middleware functions.

### `notify`

The notification service provides by default:

* `add` messages when data is modified in a statistics object
* `call` messages during call processing
* `report` messages to indicate provisioning errors

These messages might be `emit`ted against the `statistics` object during call processing. You must create the `statistics` object on the `this.cfg` object for these notifications to work. See [the `init` function in tough-rate's setup middleware](https://github.com/shimaore/tough-rate/blob/master/middleware/setup.coffee.md#init) for an example.

The notification service may be extended by `notify` middleware functions.

Middleware modules
==================

Middleware modules are declared by setting `cfg.use`. They may contain the following fields:

* `name`: the middleware name (string)
* `config`: startup (function)
* `init`: call-processing initialization (function)
* `include`: call-processing middleware (function)
* `web`: web service (function)
* `notify`: notification service (function)

The functions are executed as indicated below, in the order they are declared in the `cfg.use` array.
They are executed inside a Promise chain and may therefor return Promises.

`config` middlewares
--------------------

A `thinkable-ducks` middleware module may contain `config`-time middleware functions which are ran inside the `config` application. The `config` application is a separate process and runs before the `server` application and FreeSwitch are started.

* `config` middleware in a context comprising of `this.cfg`.

The `this.cfg` object is shared amongst all these functions, but not with the modules in the `server` application (since that application is a separate process and is ran after the `config` application is completed).

`server` middlewares
--------------------

A `thinkable-ducks` middleware module may contain `server`-time middleware functions which are ran inside the `server` application. The `server` application is a Node.js process which runs concurrently to FreeSwitch.

Some functions are executed by [`useful-wind`](https://github.com/shimaore/useful-wind):

* `init` is ran after the call-router is created but before call-routing starts taking place; this is a good place to extend the `cfg` object with any application-specific call-processing-related data.
* `include` is used to process FreeSwich calls.

Some functions are executed by this module (`thinkable-ducks`):

* `web` runs in the context of a [`zappajs`](https://github.com/zappajs/zappajs) application, extended with a `this.cfg` helper, and is used to provide web services.
* `notify` runs in a context comprising of `this.cfg` and `this.socket` (the Socket.IO client), and is used to notify and receive notifications from e.g. a [`spicy-action`](https://github.com/shimaore/spicy-action) server.

The `this.cfg` object is shared amongst all these functions.

Deployment
==========

An application is build out of middleware modules. The main application may look as follows.

`index.coffee.md`
-----------------

    cfg = require process.env.CONFIG

    cfg.use = [
      require 'huge-play/middleware/setup'
      require 'huge-play/middleware/client/media'
      # etc. `require` any middleware module you might need
    ]

    # A renderable `acoustic-line` templace to generate
    # the FreeSwitch XML configuration.
    cfg.freeswitch = require 'tough-rate/conf/freeswitch'

    ducks = require 'thinkable-ducks'
    ducks cfg

`package.json`
--------------

    npm init

`coffee-script` is required by the `supervisord.conf` scripts.

    npm install --save coffee-script

Install any middleware package you may require (including your own packages).

    npm install --save thinkable-ducks huge-play tough-rate ...

`Dockerfile`
------------

    FROM shimaore/thinkable-ducks
    COPY . /opt/thinkable-ducks
    RUN npm install

Build using docker.io
---------------------

    docker build .
