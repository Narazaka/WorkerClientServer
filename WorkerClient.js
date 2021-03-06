// Generated by CoffeeScript 1.10.0
(function() {
  var WorkerClient;

  WorkerClient = (function() {
    function WorkerClient(worker, worker_error_handler) {
      this.worker = worker;
      this.worker_error_handler = worker_error_handler != null ? worker_error_handler : this._default_worker_error_handler;
      this.worker_type = (typeof Worker !== "undefined" && Worker !== null) && this.worker instanceof Worker ? 'webworker' : 'fork';
      if (this.worker_type === "webworker") {
        this.worker.addEventListener("error", this.worker_error_handler);
        this.worker.addEventListener("message", this._response_webworker.bind(this));
      } else {
        this.worker.on("error", this.worker_error_handler);
        this.worker.on("message", this._response_fork.bind(this));
      }
      this.request_id = 0;
      this.callbacks = {};
    }

    WorkerClient.prototype.request = function(name, contents, transferable) {
      var id;
      if (contents == null) {
        contents = null;
      }
      if (transferable == null) {
        transferable = void 0;
      }
      id = this.request_id++;
      return new Promise((function(_this) {
        return function(resolve, reject) {
          var message;
          _this.callbacks[id] = function(error, contents) {
            if (error != null) {
              return reject(error);
            } else {
              return resolve(contents);
            }
          };
          message = {
            id: id,
            name: name,
            contents: contents
          };
          if (_this.worker_type === "webworker") {
            return _this.worker.postMessage(message, transferable);
          } else {
            return _this.worker.send(message);
          }
        };
      })(this));
    };

    WorkerClient.prototype._response_webworker = function(event) {
      var contents, error, id;
      id = event.data.id;
      contents = event.data.contents;
      error = event.data.error;
      this.callbacks[id](error, contents);
      return delete this.callbacks[id];
    };

    WorkerClient.prototype._response_fork = function(message) {
      var contents, error, id;
      id = message.id;
      contents = message.contents;
      error = message.error;
      this.callbacks[id](error, contents);
      return delete this.callbacks[id];
    };

    WorkerClient.prototype._default_worker_error_handler = function(event) {
      var ref;
      return console.error(((ref = event.error) != null ? ref.stack : void 0) || event.error || event);
    };

    WorkerClient.prototype.terminate = function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this.worker_type === "webworker") {
            return resolve(_this.worker.terminate());
          } else {
            _this.worker.on("exit", function(code) {
              return resolve(code);
            });
            return _this.worker.kill();
          }
        };
      })(this));
    };

    return WorkerClient;

  })();

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = WorkerClient;
  } else if (typeof window !== "undefined" && window !== null) {
    window.WorkerClient = WorkerClient;
  }

}).call(this);
