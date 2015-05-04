supervisor-controlled FreeSwitch image for useful-wind
======================================================

`index.coffee.md`
-----------------

    ducks = require 'thinkable-ducks'

    cfg = require process.env.CONFIG

    cfg.use = [
      require 'huge-play/middleware/db'
      require 'huge-play/middleware/client/force-codecs'
      # etc.
    ]

    cfg.freeswitch = require 'tough-rate/conf/freeswitch'

    ducks cfg

Install
-------

    npm install --save thinkable-ducks huge-play tough-rate ...

`coffee-script` is required by the `supervisord.conf` scripts.

    npm install --save coffee-script

`Dockerfile`
------------

    FROM shimaore/thinkable-ducks
    COPY . /opt/thinkable-ducks
    RUN npm install

Build
-----

    docker build .
