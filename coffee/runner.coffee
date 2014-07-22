GraphFactory = require './graphFactory.coffee'

module.exports = class Runner
	constructor: (@algorithm) ->
		@state = []
		@pos = 0

	colorLineNo: ->
		lineNo = (@pos % 5) + 1

		lines = document.getElementsByClassName "line"
		current = document.getElementsByClassName("line#{lineNo}")[0]

		for line in lines
			line.classList.remove "on"

		if current
			current.classList.add "on"

	next: ->
		@colorLineNo()
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
		@colorLineNo()
		if @pos isnt 0
			@pos--

			cachedVertices = @state[@pos]

			for vertex, i in cachedVertices
				for attr, key of vertex.attributes
					@algorithm.graph.vertices[i].set attr, key

	start: ->
		@playing = true
		callback = =>
			if @next()
				@timeout = setTimeout (callback), 50

		callback()

	stop: ->
		@playing = false
		clearTimeout @timeout

	playPause: ->
		if @playing then @stop() else @start()

	setFrom: (v) ->
		@algorithm.setFrom v
		@state.push(for vertex in @algorithm.graph.vertices
			vertex.clone()
		)

	setTo: (v) -> @algorithm.setTo v
