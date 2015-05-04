    describe 'Modules', ->
      it 'should compile', ->
        require '../config'
        require '../index'
        require '../notify'
        require '../server'
        require '../supervisor'
        require '../web'
