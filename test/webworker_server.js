// Generated by CoffeeScript 1.8.0
(function() {
  var handlers, server;

  importScripts('../WorkerServer.js');

  importScripts('../node_modules/bluebird/js/browser/bluebird.js');

  handlers = {
    test1: function(_arg) {
      var arg1, arg2;
      arg1 = _arg[0], arg2 = _arg[1];
      return new Promise(function(resolve, reject) {
        if (arg1 === 'test' && arg2 === 1) {
          return resolve({
            contents: 'ok'
          });
        } else {
          return reject('ng');
        }
      });
    }
  };

  server = new WorkerServer(handlers);

}).call(this);
