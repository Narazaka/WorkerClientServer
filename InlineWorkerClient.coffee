class @InlineWorkerClient extends @URLWorkerClient

	# @param [string] worker_code the server worker code
	# @param [Boolean] revoke_url_on_terminate revoke the code url when terminate()
	constructor: (worker_code, revoke_url_on_terminate=false)->
		url = URL.createObjectURL(new Blob([worker_code], {type:"text/javascript"}))
		super url, revoke_url_on_terminate
