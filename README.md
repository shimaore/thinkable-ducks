supervisor-controlled FreeSwitch image for useful-wind
======================================================

index.coffee.md

    ducks = require 'thinkable-ducks'

    cfg = require process.env.CONFIG

    cfg.use = [
      require 'huge-play/middleware/db'
      require 'huge-play/middleware/client/force-codecs'
      # etc.
    ]

    cfg.freeswitch = renderable (cfg) ->
      {doctype,document,section,configuration,settings,param,modules,module,load,network_lists,list,node,global_settings,profiles,profile,mappings,map,context,extension,condition,action} = require 'acoustic-line'
      doctype()
      document type:'freeswitch/xml', ->
        section name:'configuration', ->
          # etc.

    ducks cfg

Install

    npm install --save thinkable-ducks huge-play ...

Build

    docker build node_modules/thinkable-ducks/Dockerfile
