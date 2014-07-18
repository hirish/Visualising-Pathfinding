GraphFactory = require './graphFactory.coffee'

class AStar
	constructor: (@graph, @h = null) ->
		@open = []
		@closed = []
		@cycles = 0
		if not @h
			@h = (vertex) ->
				dx = Math.abs(vertex.x - @to.x)
				dy = Math.abs(vertex.y - @to.y)
				Math.sqrt(dx*dx + dy*dy)/30

	from: (@from) ->
		@open = [ @from ]
		@from.mark = "open"
		@from.border = true
		@graph.render()

	to: (@to) ->
		@to.border = true
		@graph.render()
	
	pickNext: ->
		if @open.length is 0
			console.error "No path exists!"
			return

		@cycles++

		next = @open[0]
		smallest = next.f

		for vertex in @open
			if vertex.f < smallest
				smallest = vertex.f
				next = vertex

		@open = @open.filter (vertex) -> vertex isnt next
		@closed.push next
		next.mark = "closed"

		@graph.render(@cycles, next)

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

		@graph.render(@cycles, @selected)

	start: ->
		callback = =>
			if @pickNext()?
				setTimeout (=>
					@addNeighbours()
					callback()
				), 100

		setTimeout callback, 100

class Dijkstra extends AStar
	constructor: (graph) ->
		super graph, (v) -> 0

a = GraphFactory.build 80, "star"
b = GraphFactory.clone a, "dijkstra"
c = GraphFactory.clone a, "starStrong"

x = new AStar a
y = new Dijkstra b
z = new AStar c, (vertex) ->
	dx = Math.abs(vertex.x - @to.x)
	dy = Math.abs(vertex.y - @to.y)
	Math.sqrt(dx*dx + dy*dy)/10

x.from a.vertices[44]
x.to a.vertices[59]
y.from b.vertices[44]
y.to b.vertices[59]
z.from c.vertices[44]
z.to c.vertices[59]

x.start()
y.start()
z.start()
