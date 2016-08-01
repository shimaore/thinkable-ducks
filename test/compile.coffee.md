    describe 'Modules', ->
      it 'should compile', ->
        require '../config'
        require '../notify'
        require '../server'
        require '../supervisor'
        require '../web'
