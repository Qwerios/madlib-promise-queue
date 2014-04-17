chai     = require "chai"
Queue    = require "../lib/queue.js"

queue = new Queue( 1 )

firstItemPromise    = undefined
secondItemPromise   = undefined

describe( "Queue", () =>
    describe( "#ready(1)", () ->
        firstItemPromise = queue.ready()

        it( "1 Running item", () ->
            chai.expect( queue.runningCount() ).to.eql( 1 )
        )
    )

    describe( "#ready(2)", () ->
        secondItemPromise = queue.ready()

        it( "1 Waiting item", () ->
            chai.expect( queue.waitingCount() ).to.eql( 1 )
        )
    )

    describe( "#done(1)", () =>
        it( "No waiting items", ( testCompleted ) =>
            firstItemPromise.then( () =>
                setTimeout( () =>
                    # Signal first queue item is done
                    # Should resolve 2nd item promise
                    #
                    queue.done()

                    chai.expect( queue.waitingCount() ).to.eql( 0 )
                    testCompleted()
                , 1000 )
            )
            .done()
        )
    )

    describe( "#done(2)", () =>
        it( "No running items", ( testCompleted ) =>
            secondItemPromise.then( () =>
                setTimeout( () =>
                    # Signal 2nd queue item is done
                    # Should empty the queue
                    #
                    queue.done()

                    chai.expect( queue.runningCount() ).to.eql( 0 )
                    testCompleted()
                , 1000 )
            )
            .done()
        )
    )
)