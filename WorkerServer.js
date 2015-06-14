// Generated by CoffeeScript 1.9.2
(function() {
  this.WorkerServer = (function() {
    function WorkerServer(handlers, worker_type) {
      this.handlers = handlers;
      this.worker_type = worker_type;
      if (this.worker_type === "webworker") {
        self.addEventListener("message", this._handler_webworker.bind(this));
      } else if (this.worker_type === 'fork') {
        process.on("message", this._handler_fork.bind(this));
      } else {
        if (typeof self !== "undefined" && self !== null) {
          self.addEventListener("message", this._handler_webworker.bind(this));
        }
        if (typeof process !== "undefined" && process !== null) {
          process.on("message", this._handler_fork.bind(this));
        }
      }
    }

    WorkerServer.prototype._handler_webworker = function(event) {
      var contents, id, name;
      id = event.data.id;
      name = event.data.name;
      contents = event.data.contents;
      this.handlers[name](contents).then(function(arg) {
        var contents, transferable;
        contents = arg.contents, transferable = arg.transferable;
        return self.postMessage({
          id: id,
          contents: contents
        }, transferable);
      }, function(error) {
        return self.postMessage({
          id: id,
          error: error
        });
      });
    };

    WorkerServer.prototype._handler_fork = function(message) {
      var contents, id, name;
      id = message.id;
      name = message.name;
      contents = message.contents;
      this.handlers[name](contents).then(function(arg) {
        var contents, transferable;
        contents = arg.contents, transferable = arg.transferable;
        return process.send({
          id: id,
          contents: contents
        }, transferable);
      }, function(error) {
        return process.send({
          id: id,
          error: error
        });
      });
    };

    return WorkerServer;

  })();

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = this.WorkerServer;
  }

}).call(this);
