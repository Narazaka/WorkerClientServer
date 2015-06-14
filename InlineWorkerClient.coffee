class @InlineWorkerClient extends @URLWorkerClient

  # @param [string] worker_code the server worker code
  # @param [Boolean] revoke_url_on_terminate revoke the code url when terminate()
  # @param [Function] worker_error_handler error handler function that will called on worker basic error with error event
  constructor: (worker_code, revoke_url_on_terminate=false, worker_error_handler)->
    url = URL.createObjectURL(new Blob([worker_code], {type:"text/javascript"}))
    super url, revoke_url_on_terminate, worker_error_handler
