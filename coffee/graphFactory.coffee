Graph = require './graph.coffee'

Vertex = Backbone.Model.extend
	clone: ->
		json = JSON.parse JSON.stringify @toJSON()
		new Vertex json

module.exports = class GraphFactory
	@EDGE_PROBABILITY: 1
	@RANGE:
		EDGE: [1,5]
		X: [50, 350]
		Y: [100, 300]
	@SIZE: 30
	@DISTANCE: 0
	@WIDTH: 10

	@NUMBER_SAMPLES: 20

	@random: (range) ->
		[lower, upper] = range

		if upper < lower
			console.error "Invalid range entered", range
			return

		multiplier = upper - lower

		return lower + Math.round(multiplier * Math.random())

	@random_edge: (v1, v2) ->
		distance = @dist [v1.get('x'), v1.get('y')], [v2.get('x'), v2.get('y')]
		addable = 1 - (Math.sqrt(distance)/100)
		
		if Math.sqrt(distance) > (2*@SIZE - 1) then return false

		return Math.random() < @EDGE_PROBABILITY

	@dist: (p1, p2) ->
		[x1, y1] = p1
		[x2, y2] = p2

		distX = x1 - x2
		distY = y1 - y2

		distX * distX + distY * distY

	@samplePos: (vertices) ->
		# Best candidate sampling

		bestSample = null
		distance = null

		for i in [0...@NUMBER_SAMPLES]
			sample = [@random(@RANGE.X), @random(@RANGE.Y)]
			nearest = _.min _.map vertices, (v) => @dist(sample, [v.x, v.y])

			if (not bestSample?) or (nearest > distance)
				bestSample = sample
				distance = nearest

		return bestSample

	@build: (size, svgClass) ->

		range = [0...size]

		vertices = []
		
		for i in range
			[x, y] = @samplePos vertices
			vertices.push new Vertex
				id: i
				width: @SIZE-@DISTANCE
				height: @SIZE-@DISTANCE
				x: (@DISTANCE/2) + @SIZE * (i % @WIDTH)
				y: (@DISTANCE/2) + @SIZE * Math.floor(i / @WIDTH)
				f: 0
				g: 0
				h: 0
				parent: null
				mark: null
				border: false

		edges =
			for i in range
				for j in range
					null

		for i in range
			for j in range
				edges[i][j] =
					if i is j then 0
					else if edges[j][i]? then edges[j][i]
					else if @random_edge(vertices[i], vertices[j]) then @random @RANGE.EDGE
					else 0

		new Graph vertices, edges, svgClass

	@clone: (graph, svgClass) ->
		vertices =
			for vertex in graph.vertices
				vertex.clone()

		edges = _.cloneDeep graph.edges
		new Graph vertices, edges, svgClass

