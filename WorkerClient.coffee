class @WorkerClient

	# @param [Worker] worker the server worker
	constructor: (@worker)->
		@worker.addEventListener "error", (event) ->
			console.error event.error?.stack || event.error || event
		@worker.addEventListener "message", (event) => @_response event
		@request_id = 0
		@callbacks = {}

	# send event request to server worker and receive response
	# @param [string] name event name
	# @param [Object] contents any value that will be passed to the server worker
	# @param [Array<Transferable>] transferable Transferable objects in the contents
	# @return [Promise] (resolve) any value that has been passed from the server worker / (reject) if response has error
	request: (name, contents=null, transferable=null) ->
		id = @request_id++
		new Promise (resolve, reject) =>
			@callbacks[id] = (error, contents) -> if error? then reject error else resolve contents
			@worker.postMessage({id: id, name: name, contents: contents}, transferable)

	# @nodoc
	_response: (event) ->
		id = event.data.id
		contents = event.data.contents
		error = event.data.error
		@callbacks[id](error, contents)
		delete @callbacks[id]

	# terminate the server worker
	# @return [Promise]
	terminate: ->
		new Promise (resolve, reject) =>
			resolve @worker.terminate()
