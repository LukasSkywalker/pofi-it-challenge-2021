require './adjacency'
require './path'
require './distance'
require 'weighted_graph'

def assertEqual(value, target)
  raise StandardError, "Expected: #{target}, actual: #{value}" if value != target
end

def assertClose(value, target, boundary = 0.01)
  raise StandardError, "Expected: #{target}, actual: #{value}" if value < (target - boundary) || value > (target + boundary)
end

p1 = { 'x' => 3, 'y' => 5 }
p2 = { 'x' => 10, 'y' => 8 }

dist = Distance.between(p1, p2)
assertClose(dist, 7.62, 0.01)

nodes = ['A', 'B', 'C', 'D', 'E']

graph = WeightedGraph::PositiveWeightedGraph.new
graph.add_undirected_edge('A', 'B', 2)
graph.add_undirected_edge('B', 'C', 2)
graph.add_undirected_edge('C', 'D', 2)
graph.add_undirected_edge('A', 'D', 10)
graph.add_undirected_edge('B', 'E', 1)

puts Adjacency.new(nodes, graph)

pa = Path.new(nodes, graph)
min_dist = pa.floyd_warshall
puts min_dist

d = Distance.new(nodes, min_dist)
puts d

puts d.shortest_path
