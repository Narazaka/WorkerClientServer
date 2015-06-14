importScripts '../WorkerServer.js'
importScripts('../node_modules/bluebird/js/browser/bluebird.js')

handlers =
  test1: ([arg1, arg2]) ->
    new Promise (resolve, reject) ->
      if arg1 == 'test' and arg2 == 1
        resolve contents: 'ok'
      else
        reject 'ng'

server = new WorkerServer(handlers)
