WorkerClientServer - WorkerClient/WorkerServer
==========================

WebWorker client/server

Installation
--------------------------

    bower install WorkerClientServer

Usage
--------------------------

### Browser

#### worker script

    importScripts('WorkerServer.js');
    
    var handlers = {
      foo: function(value){
        return new Promise(function(resolve, reject){
          resolve {contents: value + "bar"};
        });
      },
      bigdata: function(values){
        return new Promise(function(resolve, reject){
          ...
          var data = new Uint8Array(1000);
          resolve {contents: {baz: data}, transferable: [data.buffer]};
        });
      },
    };
    
    var server = new WorkerServer(handlers);

#### browser script

    var worker = new Worker('./worker.js');
    var client = new WorkerClient(worker);
    
    // or
    
    var worker_url = URL.createObjectURL(new Blob([worker_code], {type:"text/javascript"}));
    var client = new URLWorkerClient(worker_url, true);
    
    // or
    
    var client = new InlineWorkerClient(worker_code, true);
    
    client.request("foo", "data").then(function(contents){
      console.log(contents); // "databar"
    }, function(error){...});
    
    var data = new Uint8Array(1000);
    client.request("bigdata", {boo: data}, [data.buffer]).then(function(contents){
      console.log(contents.baz);
    }, function(error){...});

### node.js or nw.js with `child_process.fork()`

#### worker script

    var WorkerServer = require('WorkerServer.js');
    
    var handlers = {
      foo: function(value){
        return new Promise(function(resolve, reject){
          resolve {contents: value + "bar"};
        });
      },
    };
    
    var server = new WorkerServer(handlers);

#### main/browser script

    var WorkerClient = require('WorkerClient.js');
    var child_process = require('child_process');
    
    var worker = child_process.fork('./worker.js');
    var client = new WorkerClient(worker);
    
    client.request("foo", "data").then(function(contents){
      console.log(contents); // "databar"
    }, function(error){...});

### single file worker

    var SingleFileWorkerRunner = function(){...}; // SingleFileWorkerRunner code
    var worker_code = "";
    worker_code += "var WorkerServer = function(){...};"; // WorkerServer code string
    worker_code += "var w = new WorkerServer(...);"; // your server code string
    
    SingleFileWorkerRunner.run(worker_code, function(make_worker){
      var client = new WorkerClient(make_worker()); // your client code
      ...
    }, ('fork' || 'webworker' || null));

API
--------------------------

read the doc/ or *.coffee docs

License
--------------------------

This is released under [MIT License](http://narazaka.net/license/MIT?2015).
