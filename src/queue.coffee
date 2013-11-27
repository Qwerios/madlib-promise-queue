( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "q"
        )
    else if typeof define is "function" and define.amd
        define( [
            "q"
        ], factory )

)( ( Q ) ->

    ( limit = 10 ) ->
        queue   = []
        running = []
        timer   = 0

        ready: () =>
            deferred = Q.defer()

            if running.length < limit
                running.push( deferred )
                deferred.resolve()
            else
                queue.push( deferred )

            # Return our promise
            #
            return deferred.promise

        done: () ->
            running.pop()

            # Take the next item out of the queue
            #
            if queue.length > 0 and running.length < limit
                next = queue.shift()
                running.push( next )
                next.resolve()

        waitingCount: () ->
            queue.length

        runningCount: () ->
            running.length
)