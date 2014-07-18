AStar = require './aStar.coffee'

module.exports = class Dijkstra extends AStar
	constructor: (graph) ->
		super graph, (v) -> 0
