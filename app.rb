require 'weighted_graph'
require 'victor'
require 'adjacency_matrix'
require 'floyd_warshall'
require './distance'
require './loader'

loader = Loader.new('coordinates.json', 'connections.json')

all_coordinates = loader.coordinates
all_connections = loader.connections
all_nodes = loader.nodes

total_distance = 0
total_path = ''
combined_svg = Victor::SVG.new width: 1200, height: 400, style: { background: '#fff' }

(0..3).each do |segment|
  nodes = all_nodes[segment]
  connections = all_connections[segment]
  coordinates = all_coordinates[segment]

  svg = Victor::SVG.new width: 1200, height: 400, style: { background: '#fff' }
  coordinates.each do |name, position|
    svg.circle(cx: position['x'] * 20, cy: 400 - position['y'] * 20, r: 20, fill: 'blue')
    svg.text(name, x: position['x'] * 20, y: 400 - position['y'] * 20, font_size: 30, fill: 'red')
  end
  connections.each do |connection|
    svg.line(
      x1: connection['from']['x']* 20,
      y1: 400 - connection['from']['y'] * 20,
      x2: connection['to']['x'] * 20,
      y2: 400 - connection['to']['y'] * 20,
      style: { stroke: 'red' }
    )
  end

  graph = WeightedGraph::PositiveWeightedGraph.new

  connections.each do |connection|
    from = connection['from']
    to = connection['to']
    from_name = from['name']
    to_name = to['name']

    dist = Distance.between(from, to)
    graph.add_undirected_edge(from_name, to_name, dist)

    svg.text(dist.round(3),
      x: ((to['x'] + from['x'])/2) * 20,
      y: 400 - ((to['y'] + from['y'])/2) * 20,
      font_size: 20, fill: 'red'
    )
  end
  svg.save "segment#{segment}.svg"
  combined_svg << svg

  # create matrix containing only direct distances between nodes
  matrix = AdjacencyMatrix::Matrix.new(nodes, graph)

  # create matrix containing shortes distances, possibly traversing other nodes
  optimizer = FloydWarshall::Optimizer.new(matrix)
  shortest = optimizer.run

  # select shortest path between first and last node by trying all permutations
  d = Distance.new(nodes, shortest)
  puts "Segment: #{segment}: #{d.shortest_path}: #{d.shortest_distance}"

  total_distance += d.shortest_distance
  total_path << d.shortest_path + "\t"
end

combined_svg.save "path.svg"

puts "Total"
puts total_distance
puts total_path
