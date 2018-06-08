    describe 'Modules', ->
      it 'should compile', ->
        require '../config'
        require '../server'
        require '../freeswitch'
        require '../web'
