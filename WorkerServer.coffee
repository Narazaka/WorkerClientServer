class WorkerServer
  # @param [Hash<Function>] handlers event handler functions
  # @param [string] worker_type 'webworker', 'fork' or null (detect)
  constructor: (@handlers, @worker_type) ->
    if @worker_type == "webworker"
      self.addEventListener "message", @_handler_webworker.bind @
    else if @worker_type == 'fork'
      process.on "message", @_handler_fork.bind @
    else
      self?.addEventListener "message", @_handler_webworker.bind @
      process?.on "message", @_handler_fork.bind @

  # @nodoc
  _handler_webworker: (event) ->
    id = event.data.id
    name = event.data.name
    contents = event.data.contents
    @handlers[name](contents)
    .then ({contents, transferable}) ->
      self.postMessage({id: id, contents: contents}, transferable)
    , (error) ->
      self.postMessage({id: id, error: error})
    return

  # @nodoc
  _handler_fork: (message) ->
    id = message.id
    name = message.name
    contents = message.contents
    @handlers[name](contents)
    .then ({contents, transferable}) ->
      process.send({id: id, contents: contents}, transferable)
    , (error) ->
      process.send({id: id, error: error})
    return

if module?.exports?
  module.exports = WorkerServer
else if window?
  window.WorkerServer = WorkerServer
