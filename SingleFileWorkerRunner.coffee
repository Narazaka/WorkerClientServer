class SingleFileWorkerRunner

  # @param [string] worker_code the server worker code
  # @param [Function] client_function the client code that will called with make_worker function
  # @param [string] worker_type 'webworker', 'fork' or null (detect)
  @run: (worker_code, client_function, worker_type=(if require? then 'fork' else 'webworker')) ->
    if window? # browser context
      client_function(if worker_type == 'fork' then SingleFileWorkerRunner.main_fork() else SingleFileWorkerRunner.main_webworker(worker_code))
    else
      SingleFileWorkerRunner.child(worker_code)

  # @nodoc
  @main_fork: ->
    child_process = require 'child_process'
    try
      throw new Error()
    catch error
      scriptname = error.stack.match(/\w+:\/\/+[^\/]+\/[^:]+/)[0] # evil
    -> child_process.fork scriptname

  # @nodoc
  @main_webworker: (worker_code) ->
    worker_url = URL.createObjectURL(new Blob([worker_code], {type:"text/javascript"}))
    -> new Worker worker_url

  # @nodoc
  @child: (worker_code) ->
    eval worker_code

if module?.exports?
  module.exports = SingleFileWorkerRunner
else
  @SingleFileWorkerRunner = SingleFileWorkerRunner
