    pkg = require './package'
    @name = "#{pkg.name}:munin"
    debug = (require 'debug') @name

Web Services for Munin
======================

    run = (cfg) ->
      cfg.munin ?= {}
      cfg.munin.host ?= process.env.MUNIN_HOST ? '127.0.0.1'
      port = null
      if process.env.MUNIN_PORT?
        port = parseInt process.env.MUNIN_PORT
        port = null if isNaN port
      cfg.munin.port ?= port ? 3950
      cfg.munin.io ?= false

      config = build_config cfg

      Zappa cfg.munin, ->

        @get '/autoconf', ->
          @send 'yes\n'
          return

        @get '/config', ->
          @send config
          return

        @get '/', ->
          memory = process.memoryUsage()
          text = """
            multigraph #{name}_node_uptime
            #{name}_node_uptime.value #{process.uptime()}

            multigraph #{name}_node_memory
            #{name}_node_memory_rss.value #{memory.rss}
            #{name}_node_memory_heap_total.value #{memory.heapTotal}
            #{name}_node_memory_heap_used.value #{memory.heapUsed}

            multigraph #{name}_hugeplay

          """
          @send text

Munin Configuration
===================

    name = process.env.MUNIN_NAME ? 'freeswitch'

    build_config = (cfg) ->
      text = """
        multigraph #{name}_node_uptime
        graph_args --base 1000 -l 0
        graph_category voice
        graph_scale no
        graph_title Node.js uptime
        graph_vlabel seconds
        #{name}_node_uptime.label uptime
        #{name}_node_uptime.draw AREA

        multigraph #{name}_node_memory
        graph_args --base 1024 -l 0
        graph_category voice
        graph_title Node.js memory
        graph_vlabel bytes
        #{name}_node_memory_rss.label rss
        #{name}_node_memory_rss.min 0
        #{name}_node_memory_heap_total.label heap (total)
        #{name}_node_memory_heap_total.min 0
        #{name}_node_memory_heap_used.label heap (used)
        #{name}_node_memory_heap_used.min 0

        multigraph #{name}_hugeplay
        graph_args --base 1000 -l 0
        graph_category voice
        graph_title Durations
        graph_vlabel ${graph_period}

      """
      text

Toolbox
=======

    Zappa = require 'core-zappa'
    module.exports = run
