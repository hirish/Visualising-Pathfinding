module.exports = class Graph
	constructor: (@vertices, @edges, @svgClass) ->
		@radius = 100
		@centerX = 200
		@centerY = 200

		@size = @vertices.length

		@startAngle = 0
		@incAngle = -0.002

		@colors = d3.scale.quantize()
			.domain [0,11]
			.range ["#006837", "#1a9850", "#66bd63",
							"#a6d96a", "#d9ef8b", "#ffffbf",
							"#fee08b", "#fdae61", "#f46d43",
							"#d73027", "#a50026"]

		@render()

	neighbours: (node) ->
		weights = @edges[node.i]
		vertices = _.map weights, (w, i) => if w > 0 then @vertices[i]
		_.filter vertices, (v) -> v?
	
	verticeShapes: ->
		if @_vertices? then @_vertices
		else
			@_vertices = d3
				.select 'svg.' + @svgClass
				.selectAll 'rect'
				.data @vertices
				.enter()
				.append 'rect'

	lines: ->
		if @_lines? then @_lines
		else
			lines = []

			for i in [0...@size]
				for j in [0...i]
					if @edges[i][j] > 0
						lines.push
							x1: @vertices[i].x + @vertices[i].r/2
							y1: @vertices[i].y + @vertices[i].r/2
							x2: @vertices[j].x + @vertices[j].r/2
							y2: @vertices[j].y + @vertices[j].r/2
							w: @edges[i][j]

			@_lines = d3
				.select 'svg.' + @svgClass
				.selectAll 'line'
				.data lines
				.enter()
				.append 'line'

	render: (cycles=0, selected=null) ->
		# @lines()
		# 	.attr 'x1', (v) -> v.x1
		# 	.attr 'y1', (v) -> v.y1
		# 	.attr 'x2', (v) -> v.x2
		# 	.attr 'y2', (v) -> v.y2
		# 	.attr 'stroke', '#333'

		@verticeShapes()
			.attr 'x', (v) -> v.x
			.attr 'y', (v) -> v.y
			.attr 'width', (v) -> v.r
			.attr 'height', (v) -> v.r
			.style 'fill', (v) =>
				if v.mark is "open"
					'rgba(0,0,0,0)'
				else if v.mark is "closed"
					@colors v.g
				else
					'#333'
			.style 'stroke', (v) -> if v.border then '#09c' else 'none'

		d3.select "##{@svgClass}Cycles"
			.text cycles

		d3.select "##{@svgClass}Size"
			.text if selected? then selected.g else 0
