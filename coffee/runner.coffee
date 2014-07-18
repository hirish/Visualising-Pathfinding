GraphFactory = require './graphFactory.coffee'

module.exports = class Runner
	constructor: (@algorithm) ->
		@state = []
		@pos = 0

	next: ->
		if @pos is @state.length - 1
			x = @algorithm.next()
			@state.push _.cloneDeep @algorithm.graph.vertices
			@pos++
			return x
		else
			@pos++
			cachedVertices = @state[@pos]

			for vertex, i in cachedVertices
				for attr, key of vertex
					@algorithm.graph.vertices[i][attr] = key

			@algorithm.graph.render()
			return true

	prev: ->
		if @pos isnt 0
			@pos--

			cachedVertices = @state[@pos]

			for vertex, i in cachedVertices
				for attr, key of vertex
					@algorithm.graph.vertices[i][attr] = key

			@algorithm.graph.render()

	start: ->
		callback = =>
			if @next()?
				setTimeout (callback), 50

		callback()

	setFrom: (v) ->
		@algorithm.setFrom v
		@state.push _.cloneDeep @algorithm.graph.vertices
	setTo: (v) -> @algorithm.setTo v
