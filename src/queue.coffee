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

    ###*
    #   A promise based queue
    #
    #   @author     mdoeswijk
    #   @module     queue
    #   @constructor
    #   @param  {Number}    limit   The amount of items allowed to be running
    #   @param  {String}    type    The type of queue. One of: fifo (First in, first out), lifo (Last in, first out)
    #   @version    0.1
    ###
    ( limit = 10, type = "fifo" ) ->
        queue   = []
        running = []
        timer   = 0

        ###*
        #   Gets a promise from the queue that will resolve when there is a slot available
        #
        #   @function ready
        #
        #   @return {Promise}   Will resolve when a slot if available in the queue
        #
        ###
        ready: () ->
            deferred = Q.defer()

            if running.length < limit
                running.push( deferred )
                deferred.resolve()
            else
                queue.push( deferred )

            # Return our promise
            #
            return deferred.promise

        ###*
        #   Signals the queue an item is done running
        #
        #   @function ready
        #
        #   @return None
        #
        ###
        done: () ->
            # This doesn't have to remove the promise from the running array
            # that is actually done but this doesn't matter for the function
            # this queue is fulfilling. Just don't iterate the running array
            # expecting those promises to be the active items. It's just a count
            #
            running.pop()

            # Take the next item out of the queue
            #
            if queue.length > 0 and running.length < limit
                switch type
                    when "lifo"
                        next = queue.pop()
                    else
                        # First in, first out is the (backwards compatible) default
                        #
                        next = queue.shift()

                running.push( next )
                next.resolve()

        ###*
        #   Flushes the queue. Will reject any remaining promises
        #
        #   @function flush
        #
        #   @return None
        #
        ###
        flush: () ->
            while promise = queue.pop()
                promise.reject( "flush" )

            while promise = running.pop()
                promise.reject( "flush" )

            return

        ###*
        #   Retrieves the amount of waiting items in the queue
        #
        #   @function waitingCount
        #
        #   @return {Number}    The amount of waiting items
        #
        ###
        waitingCount: () ->
            queue.length

        ###*
        #   Retrieves the amount of running items in the queue
        #
        #   @function runningCount
        #
        #   @return {Number}    The amount of running items
        #
        ###
        runningCount: () ->
            running.length
)