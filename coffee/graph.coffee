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
			# .range ["#67001f","#b2182b","#d6604d",
			# 				"#f4a582","#fddbc7","#ffffff",
			# 				"#e0e0e0","#bababa","#878787",
			# 				"#4d4d4d","#1a1a1a"].reverse()

		for vertex in @vertices
			vertex.on 'change',  => @render()

	neighbours: (node) ->
		weights = @edges[node.get 'id']
		vertices = _.map weights, (w, i) => if w > 0 then @vertices[i]
		_.filter vertices, (v) -> v?
	
	verticeShapes: ->
		if @_vertices? then @_vertices
		else
			console.log 'uncached'
			@_vertices = d3
				.select 'svg.' + @svgClass
				.selectAll 'rect'
				.data @vertices
				.enter()
				.append 'rect'

	render: () ->
		@verticeShapes()
			.attr 'x', (v) -> v.get 'x'
			.attr 'y', (v) -> v.get 'y'
			.attr 'width', (v) -> v.get 'width'
			.attr 'height', (v) -> v.get 'height'
			.style 'fill', (v) =>
				if v.get('mark') is "open"
					# 'rgba(0,0,0,0)'
					'#333'
				else if v.get('mark') is "closed"
					@colors v.get 'g'
				else
					# '#333'
					'white'
			.style 'stroke', (v) =>
				# if v.get 'border'
				# 	'#09c'
				if v.get('mark') is "closed"
					d3.rgb(@colors v.get 'g').darker()
				else if v.get('mark') isnt "open"
					'#999'
				else
					'black'
			.style 'stroke-width', (v) ->
				if v.get 'border'
					1
				else
					1
