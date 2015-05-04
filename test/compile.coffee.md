    describe 'Modules', ->
      it 'should compile', ->
        require '../config'
        require '../index'
        require '../notify'
        require '../server'
        require '../supervisor'
        require '../web'

      it 'should return a function', ->
        process.env.MODE = 'test'
        m = require '../index'
        m {}
