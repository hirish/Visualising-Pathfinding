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
			# There is an old from to be reset, and the
			# algorithm hasn't started.
			@from.set mark: null, border: false

		else if @from?
			# There is an old from, but the algorithm has
			# started.
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
	
	checkPath: ->
		if @open.length is 0
			# We've exhausted all reachable vertices.
			console.error "No path exists!"
			return false

	selectSmallestF: ->
		# Get the vertex in the open list with smallest f val.
		next = @open[0]
		smallest = next.get 'f'
		for vertex in @open
			if vertex.get('f') < smallest
				smallest = vertex.get 'f'
				next = vertex
		@selected = next
	
	checkDest: ->
		if @selected is @to
			console.log "Found!"
			return false

	closeSelected: ->
		# Move it from open -> closed list.
		@open = @open.filter (vertex) => vertex isnt @selected
		@closed.push @selected
		@selected.set mark: "closed"

	pickNext: ->
		if not @checkPath() then return false

		# Get the vertex in the open list with smallest f val.
		@getSmallestF()

		# Move it from open -> closed list.
		@closeSelected

		# Check whether we've reached our destination.
		@checkDest()

		return true

	addNeighbours: ->
		neighbours = @graph.neighbours @selected
		for vertex in neighbours
			if vertex in @closed then continue

			# The weight to move from current vertex to this one.
			w = @graph.edges[@selected.get 'id'][vertex.get 'id']

			g = @selected.get('g') + w
			h = @h(vertex)
			f = g + h

			if vertex in @open
				if g < vertex.get 'g'
					# We found a quicker path to this vertex.
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
			{ fn: @checkPath, lineNo: 1 }
			{ fn: @selectSmallestF, lineNo: 2 }
			{ fn: @closeSelected, lineNo: 3 }
			{ fn: @checkDest, lineNo: 4 }
			{ fn: @addNeighbours, lineNo: 5 }
		]

		if not @counter? then return

		{fn, lineNo} = runtimeOrder[@counter++ % runtimeOrder.length]

		res = fn.apply @

		lines = document.getElementsByClassName "line"
		current = document.getElementsByClassName("line#{lineNo}")[0]

		for line in lines
			line.classList.remove "on"

		if current
			console.log current
			current.classList.add "on"

		# If a fn returns false, the algorithm terminates.
		if res? and not res
			@counter = null
		else
			true
