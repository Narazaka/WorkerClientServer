class URLWorkerClient extends WorkerClient

  # @param [URL] url the server worker code url
  # @param [Boolean] revoke_url_on_terminate revoke the code url when terminate()
  # @param [Function] worker_error_handler error handler function that will called on worker basic error with error event
  constructor: (@url, @revoke_url_on_terminate=false, worker_error_handler)->
    super new Worker(@url, worker_error_handler)

  # terminate the server worker and revoke URL if revoke_url_on_terminate
  # @return [Promise]
  terminate: ->
    if @revoke_url_on_terminate
      super()
      .then =>
        URL.revokeObjectURL(@url)
    else
      super()

if window?
  window.URLWorkerClient = URLWorkerClient
