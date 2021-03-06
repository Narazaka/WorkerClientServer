// Generated by CoffeeScript 1.10.0
(function() {
  var URLWorkerClient,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  URLWorkerClient = (function(superClass) {
    extend(URLWorkerClient, superClass);

    function URLWorkerClient(url, revoke_url_on_terminate, worker_error_handler) {
      this.url = url;
      this.revoke_url_on_terminate = revoke_url_on_terminate != null ? revoke_url_on_terminate : false;
      URLWorkerClient.__super__.constructor.call(this, new Worker(this.url, worker_error_handler));
    }

    URLWorkerClient.prototype.terminate = function() {
      if (this.revoke_url_on_terminate) {
        return URLWorkerClient.__super__.terminate.call(this).then((function(_this) {
          return function() {
            return URL.revokeObjectURL(_this.url);
          };
        })(this));
      } else {
        return URLWorkerClient.__super__.terminate.call(this);
      }
    };

    return URLWorkerClient;

  })(WorkerClient);

  if (typeof window !== "undefined" && window !== null) {
    window.URLWorkerClient = URLWorkerClient;
  }

}).call(this);
