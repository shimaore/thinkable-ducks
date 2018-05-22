    chai = require 'chai'
    chai.should()
    request = require 'superagent'

    describe 'Basic web service', ->
      app = null
      before ->
        CaringBand = require 'caring-band'
        statistics = new CaringBand()
        options =
          web:
            port: 5704
          statistics: statistics
        app = (require '../web') options
        statistics.add 'foo', 2
      after ->
        app.server?.close()

      it 'should respond', ->
        request.get 'http://127.0.0.1:5704/'
        .then ({body}) ->
          body.should.have.property 'ok', true
          body.should.have.property 'versions'

      it 'should provide all statistics', ->
        request.get 'http://127.0.0.1:5704/statistics'
        .then ({body}) ->
          body.should.have.property 'foo'
          body.foo.should.have.property 'count', 1

    describe 'Munin web service', ->
      app = null
      before ->
        CaringBand = require 'caring-band'
        statistics = new CaringBand()
        cfg =
          statistics: statistics
        app = (require '../munin') cfg
        statistics.add 'duration', 2
      after ->
        app.server?.close()

      it 'should respond', ->
        request.get 'http://127.0.0.1:3950/'
        .then ({text}) ->
          text.should.match /multigraph/

      it 'should respond for config', ->
        request.get 'http://127.0.0.1:3950/config'
        .then ({text}) ->
          text.should.match /multigraph/

      it 'should provide statistics', ->
        request.get 'http://127.0.0.1:3950/'
        .then ({text}) ->
          text.should.match /\nmultigraph freeswitch_hugeplay\nfreeswitch_hugeplay_duration.value 2\n/
