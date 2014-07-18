module.exports = class AStar
	constructor: (@graph, @h = null) ->
		@counter = 0
		@open = []
		@closed = []
		if not @h
			@h = (vertex) ->
				dx = Math.abs(vertex.get('x') - @to.get('x'))
				dy = Math.abs(vertex.get('y') - @to.get('y'))
				Math.sqrt(dx*dx + dy*dy)/30

	setFrom: (from) ->
		if @open.length is 1 and @open[0] is @from
			@from.mark = "open"
			@from.border = true
		else if @from?
			console.error "Cannot set from"
			return false

		@from = from
		@open = [ @from ]
		@from.set mark: "open", border: true

	setTo: (to) ->
		if @to? then to.set border: false
		if to is @from
			console.error "Cannot set to"
			return false

		@to = to
		@to.set border: true
	
	pickNext: ->
		if @open.length is 0
			console.error "No path exists!"
			return false

		next = @open[0]
		smallest = next.get 'f'

		for vertex in @open
			if vertex.get('f') < smallest
				smallest = vertex.get 'f'
				next = vertex

		@open = @open.filter (vertex) -> vertex isnt next
		@closed.push next
		next.set mark: "closed"

		if next is @to
			console.log "Found!"
			return false

		@selected = next
		return true

	addNeighbours: ->
		neighbours = @graph.neighbours @selected
		for vertex in neighbours
			if vertex in @closed then continue

			w = @graph.edges[@selected.get 'id'][vertex.get 'id']
			g = @selected.get('g') + w
			h = @h(vertex)
			f = g + h

			if vertex in @open
				if g < vertex.get 'g'
					vertex.set g: g, parent: @selected
			else
				vertex.set
					g: g
					h: h
					f: f
					parent: @selected
					mark: "open"

				@open.push vertex

		return true

	next: ->
		runtimeOrder = [
			{ fn: @pickNext, lineNo: 1 }
			{ fn: @addNeighbours, lineNo: 4 }
		]

		if not @counter? then return

		fn = runtimeOrder[@counter++ % runtimeOrder.length].fn
		res = fn.apply @

		if not res then @counter = null
		res
