Runner = require './runner.coffee'
GraphFactory = require './graphFactory.coffee'
AStar = require './algorithms/aStar.coffee'
Dijkstra = require './algorithms/dijkstra.coffee'

a = GraphFactory.build 80, "dijkstra"
# b = GraphFactory.clone a, "star"
# c = GraphFactory.clone a, "starStrong"

a.render()
# b.render()
# c.render()

window.x = new Runner new Dijkstra a
# window.y = new Runner new AStar b
# window.z = new AStar c, (vertex) ->
# 	dx = Math.abs(vertex.x - @to.x)
# 	dy = Math.abs(vertex.y - @to.y)
# 	Math.sqrt(dx*dx + dy*dy)/10

x.setFrom a.vertices[44]
x.setTo a.vertices[59]
# y.setFrom b.vertices[44]
# y.setTo b.vertices[59]
# z.setFrom c.vertices[44]
# z.setTo c.vertices[59]

# x.start()
# y.start()
# z.start()
