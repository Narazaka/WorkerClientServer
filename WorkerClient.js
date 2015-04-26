// Generated by CoffeeScript 1.9.2
(function() {
  this.WorkerClient = (function() {
    function WorkerClient(worker) {
      this.worker = worker;
      this.worker.addEventListener("error", function(event) {
        var ref;
        return console.error(((ref = event.error) != null ? ref.stack : void 0) || event.error || event);
      });
      this.worker.addEventListener("message", (function(_this) {
        return function(event) {
          return _this._response(event);
        };
      })(this));
      this.request_id = 0;
      this.callbacks = {};
    }

    WorkerClient.prototype.request = function(name, contents, transferable) {
      var id;
      if (contents == null) {
        contents = null;
      }
      if (transferable == null) {
        transferable = null;
      }
      id = this.request_id++;
      return new Promise((function(_this) {
        return function(resolve, reject) {
          _this.callbacks[id] = function(error, contents) {
            if (error != null) {
              return reject(error);
            } else {
              return resolve(contents);
            }
          };
          return _this.worker.postMessage({
            id: id,
            name: name,
            contents: contents
          }, transferable);
        };
      })(this));
    };

    WorkerClient.prototype._response = function(event) {
      var contents, error, id;
      id = event.data.id;
      contents = event.data.contents;
      error = event.data.error;
      this.callbacks[id](error, contents);
      return delete this.callbacks[id];
    };

    WorkerClient.prototype.terminate = function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          return resolve(_this.worker.terminate());
        };
      })(this));
    };

    return WorkerClient;

  })();

}).call(this);
