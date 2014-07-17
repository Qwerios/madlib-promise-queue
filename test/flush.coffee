chai     = require "chai"
Queue    = require "../lib/queue.js"

queue = new Queue( 1 )

firstItemPromise    = undefined
secondItemPromise   = undefined
thirdItemPromise    = undefined

describe( "Flush Queue", () =>
    describe( "#ready(13)", () ->
        firstItemPromise  = queue.ready()
        secondItemPromise = queue.ready()
        thirdItemPromise  = queue.ready()

        it( "1 Running item", () ->
            chai.expect( queue.runningCount() ).to.eql( 1 )
        )
        it( "2 Waiting items", () ->
            chai.expect( queue.waitingCount() ).to.eql( 2 )
        )
    )

    describe( "#flush", () =>
        it( "No more items in queue", () =>
            queue.flush()
        )
        it( "0 Running items", () ->
            chai.expect( queue.runningCount() ).to.eql( 0 )
        )
        it( "0 Waiting items", () ->
            chai.expect( queue.waitingCount() ).to.eql( 0 )
        )

        it( "3 Non-pending promises", () ->
            chai.expect( firstItemPromise.isPending()  ).to.eql( false )
            chai.expect( secondItemPromise.isPending() ).to.eql( false )
            chai.expect( thirdItemPromise.isPending()  ).to.eql( false )
        )
    )
)