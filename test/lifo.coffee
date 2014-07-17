chai     = require "chai"
Queue    = require "../lib/queue.js"

queue = new Queue( 1, "lifo" )

firstItemPromise    = undefined
secondItemPromise   = undefined
thirdItemPromise    = undefined

describe( "LIFO Queue", () =>
    describe( "#ready(1)", () ->
        firstItemPromise = queue.ready()

        it( "1 Running item", () ->
            chai.expect( queue.runningCount() ).to.eql( 1 )
        )
    )

    describe( "#done(1)", () =>
        secondItemPromise = queue.ready()
        thirdItemPromise  = queue.ready()

        it( "Last item goes first", ( testCompleted ) =>
            firstItemPromise.then( () =>
                setTimeout( () =>
                    # Signal first queue item is done
                    # Should resolve 3rd item promise
                    #
                    queue.done()

                    chai.expect( thirdItemPromise.isFulfilled() ).to.eql( true )
                    testCompleted()
                , 1000 )
            )
            .done()
        )
    )
)