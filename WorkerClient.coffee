class @WorkerClient

  # @param [Worker] worker the server worker
  constructor: (@worker, @worker_error_handler=@_default_worker_error_handler, @worker_type=(if process? then 'fork' else 'webworker'))->
    if @worker_type == "webworker"
      @worker.addEventListener "error", @worker_error_handler
      @worker.addEventListener "message", @_response_webworker.bind @
    else
      @worker.on "error", @worker_error_handler
      @worker.on "message", @_response_fork.bind @
    @request_id = 0
    @callbacks = {}

  # send event request to server worker and receive response
  # @param [string] name event name
  # @param [Object] contents any value that will be passed to the server worker
  # @param [Array<Transferable>] transferable Transferable objects in the contents
  # @return [Promise] (resolve) any value that has been passed from the server worker / (reject) if response has error
  request: (name, contents=null, transferable=undefined) ->
    id = @request_id++
    new Promise (resolve, reject) =>
      @callbacks[id] = (error, contents) -> if error? then reject error else resolve contents
      message = {id: id, name: name, contents: contents}
      if @worker_type == "webworker"
        @worker.postMessage(message, transferable)
      else
        @worker.send(message)

  # @nodoc
  _response_webworker: (event) ->
    id = event.data.id
    contents = event.data.contents
    error = event.data.error
    @callbacks[id](error, contents)
    delete @callbacks[id]

  # @nodoc
  _response_fork: (message) ->
    id = message.id
    contents = message.contents
    error = message.error
    @callbacks[id](error, contents)
    delete @callbacks[id]

  # @nodoc
  _default_worker_error_handler: (event) ->
    console.error event.error?.stack || event.error || event

  # terminate the server worker
  # @return [Promise]
  terminate: ->
    new Promise (resolve, reject) =>
      if @worker_type == "webworker"
        resolve @worker.terminate()
      else
        @worker.on "exit", (code) ->
          resolve code
        @worker.kill()

if module?.exports?
  module.exports = @WorkerClient
