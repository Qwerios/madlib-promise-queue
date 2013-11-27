(function() {
  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory(require("q"));
    } else if (typeof define === "function" && define.amd) {
      return define(["q"], factory);
    }
  })(function(Q) {
    return function(limit) {
      var queue, running, timer,
        _this = this;
      if (limit == null) {
        limit = 10;
      }
      queue = [];
      running = [];
      timer = 0;
      return {
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
        done: function() {
          var next;
          running.pop();
          if (queue.length > 0 && running.length < limit) {
            next = queue.shift();
            running.push(next);
            return next.resolve();
          }
        },
        waitingCount: function() {
          return queue.length;
        },
        runningCount: function() {
          return running.length;
        }
      };
    };
  });

}).call(this);
