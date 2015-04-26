class WorkerServer
	constructor: (@handlers) ->
		self.addEventListener "message", (event)->
			id = event.data.id
			name = event.data.name
			contents = event.data.contents
			@handlers[name](contents)
			.then ({contents, transferable}) ->
				self.postMessage({id: id, contents: contents}, transferable)
			, (error) ->
				self.postMessage({id: id, error: error})
			return

@WorkerServer = WorkerServer
