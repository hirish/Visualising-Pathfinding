module.exports = class AStar
	constructor: (@graph, @h = null) ->
		@open = []
		@closed = []
		if not @h
			@h = (vertex) ->
				dx = Math.abs(vertex.x - @to.x)
				dy = Math.abs(vertex.y - @to.y)
				Math.sqrt(dx*dx + dy*dy)/30

	setFrom: (from) ->
		if @open.length is 1 and @open[0] is @from
			@from.mark = "open"
			@from.border = true
		else if @from?
			console.error "Cannot set from"
			return

		@from = from
		@open = [ @from ]
		@from.mark = "open"
		@from.border = true
		@graph.render()

	setTo: (to) ->
		if @to? then to.border = false
		if to is @from
			console.error "Cannot set to"
			return

		@to = to
		@to.border = true
		@graph.render()
	
	pickNext: ->
		if @open.length is 0
			console.error "No path exists!"
			return

		next = @open[0]
		smallest = next.f

		for vertex in @open
			if vertex.f < smallest
				smallest = vertex.f
				next = vertex

		@open = @open.filter (vertex) -> vertex isnt next
		@closed.push next
		next.mark = "closed"

		@graph.render()

		if next is @to
			console.log "Found!"
			return

		@selected = next

	addNeighbours: ->
		neighbours = @graph.neighbours @selected
		for vertex in neighbours
			if vertex in @closed then continue

			w = @graph.edges[@selected.i][vertex.i]
			g = @selected.g + w
			h = @h(vertex)
			f = g + h

			if vertex in @open
				if g < vertex.g
					vertex.g = g
					vertex.parent = @selected
			else
				vertex.g = g
				vertex.h = h
				vertex.f = f
				vertex.parent = @selected
				vertex.mark = "open"
				@open.push vertex

		@graph.render()

	next: ->
		if @pickNext()?
			@addNeighbours()
		else
			return
