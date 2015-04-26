class URLWorkerClient extends WorkerClient

	# @param [URL] url the server worker code url
	# @param [Boolean] revoke_url_on_terminate revoke the code url when terminate()
	constructor: (@url, @revoke_url_on_terminate=false)->
		super new Worker(@url)

	# terminate the server worker and revoke URL if revoke_url_on_terminate
	# @return [Promise]
	terminate: ->
		if @revoke_url_on_terminate
			super()
			.then =>
				URL.revokeObjectURL(@url)
		else
			super()
