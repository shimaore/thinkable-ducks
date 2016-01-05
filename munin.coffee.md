    pkg = require './package'
    @name = "#{pkg.name}:munin"
    debug = (require 'debug') @name

Web Services for Munin
======================

    run = (cfg) ->
      cfg.munin ?= {}
      cfg.munin.host ?= process.env.MUNIN_HOST ? '127.0.0.1'
      cfg.munin.port ?= process.env.MUNIN_PORT ? 3950
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
          for key in hugeplay_keys
            value = cfg.statistics?.get key
            if value?
              text += """
                #{name}_hugeplay_#{key}.value #{value.sum.toDecimal 0}

              """

          @send text

Munin Configuration
===================

    name = 'freeswitch'
    hugeplay_keys = ['duration','billable','progress','answer','wait','progress_media','flow_bill']

    build_config = (cfg) ->
      text = """
        multigraph #{name}_node_uptime
        graph_title Node.js uptime
        graph_args --base 1000 -l 0
        graph_scale no
        graph_vlabel seconds
        graph_category voice
        #{name}_node_uptime.label uptime
        #{name}_node_uptime.draw AREA

        multigraph #{name}_node_memory
        graph_title Node.js memory
        graph_vlabel bytes
        graph_category voice
        #{name}_node_memory_rss.label rss
        #{name}_node_memory_rss.min 0
        #{name}_node_memory_heap_total.label heap (total)
        #{name}_node_memory_heap_total.min 0
        #{name}_node_memory_heap_used.label heap (used)
        #{name}_node_memory_heap_used.min 0

        multigraph #{name}_hugeplay
        graph_title Durations
        graph_vlabel ${graph_period}
        graph_args --base 1000
        graph_category voice

      """
      for key in hugeplay_keys
        text += """
          #{name}_hugeplay_#{key}.label #{key}
          #{name}_hugeplay_#{key}.type DERIVE
          #{name}_hugeplay_#{key}.min 0

        """

      text

Toolbox
=======

    Zappa = require 'zappajs'
    module.exports = run
