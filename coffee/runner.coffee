GraphFactory = require './graphFactory.coffee'

module.exports = class Runner
	constructor: (@algorithm) ->
		@state = []
		@pos = 0

	next: ->
		if @pos is @state.length - 1
			x = @algorithm.next()

			@state.push(for vertex in @algorithm.graph.vertices
				vertex.clone()
			)

			@pos++
			return x
		else
			@pos++
			cachedVertices = @state[@pos]

			for vertex, i in cachedVertices
				for attr, key of vertex.attributes
					@algorithm.graph.vertices[i].set attr, key

			return true

	prev: ->
		if @pos isnt 0
			@pos--

			cachedVertices = @state[@pos]

			for vertex, i in cachedVertices
				for attr, key of vertex.attributes
					@algorithm.graph.vertices[i].set attr, key

	start: ->
		callback = =>
			if @next()
				setTimeout (callback), 50

		callback()

	setFrom: (v) ->
		@algorithm.setFrom v
		@state.push(for vertex in @algorithm.graph.vertices
			vertex.clone()
		)

	setTo: (v) -> @algorithm.setTo v
