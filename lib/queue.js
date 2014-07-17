(function() {
  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory(require("q"));
    } else if (typeof define === "function" && define.amd) {
      return define(["q"], factory);
    }
  })(function(Q) {

    /**
     *   A promise based queue
     *
     *   @author     mdoeswijk
     *   @module     queue
     *   @constructor
     *   @param  {Number}    limit   The amount of items allowed to be running
     *   @param  {String}    type    The type of queue. One of: fifo (First in, first out), lifo (Last in, first out)
     *   @version    0.1
     */
    return function(limit, type) {
      var queue, running, timer;
      if (limit == null) {
        limit = 10;
      }
      if (type == null) {
        type = "fifo";
      }
      queue = [];
      running = [];
      timer = 0;
      return {

        /**
         *   Gets a promise from the queue that will resolve when there is a slot available
         *
         *   @function ready
         *
         *   @return {Promise}   Will resolve when a slot if available in the queue
         *
         */
        ready: function() {
          var deferred;
          deferred = Q.defer();
          if (running.length < limit) {
            running.push(deferred);
            deferred.resolve();
          } else {
            queue.push(deferred);
          }
          return deferred.promise;
        },

        /**
         *   Signals the queue an item is done running
         *
         *   @function ready
         *
         *   @return None
         *
         */
        done: function() {
          var next;
          running.pop();
          if (queue.length > 0 && running.length < limit) {
            switch (type) {
              case "lifo":
                next = queue.pop();
                break;
              default:
                next = queue.shift();
            }
            running.push(next);
            return next.resolve();
          }
        },

        /**
         *   Flushes the queue. Will reject any remaining promises
         *
         *   @function flush
         *
         *   @return None
         *
         */
        flush: function() {
          var promise;
          while (promise = queue.pop()) {
            promise.reject("flush");
          }
          while (promise = running.pop()) {
            promise.reject("flush");
          }
        },

        /**
         *   Retrieves the amount of waiting items in the queue
         *
         *   @function waitingCount
         *
         *   @return {Number}    The amount of waiting items
         *
         */
        waitingCount: function() {
          return queue.length;
        },

        /**
         *   Retrieves the amount of running items in the queue
         *
         *   @function runningCount
         *
         *   @return {Number}    The amount of running items
         *
         */
        runningCount: function() {
          return running.length;
        }
      };
    };
  });

}).call(this);
