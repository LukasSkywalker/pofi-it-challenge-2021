require 'weighted_graph'
require 'json'
require 'victor'
require './adjacency'
require './path'
require './distance'

all_coordinates = JSON.parse(File.read('coordinates.json'))
all_connections = JSON.parse(File.read('connections.json'))

total_distance = 0
total_path = ''
combined_svg = Victor::SVG.new width: 1200, height: 400, style: { background: '#fff' }

(0..3).each do |segment|
  nodes = all_coordinates[segment].keys
  connections = all_connections[segment]
  coordinates = all_coordinates[segment]

  svg = Victor::SVG.new width: 1200, height: 400, style: { background: '#fff' }
  coordinates.each do |name, position|
    svg.circle(cx: position['x'] * 20, cy: 400 - position['y'] * 20, r: 20, fill: 'blue')
    svg.text(name, x: position['x'] * 20, y: 400 - position['y'] * 20, font_size: 30, fill: 'red')
  end
  connections.each do |connection|
    from = coordinates[connection['from']]
    to = coordinates[connection['to']]
    svg.line(
      x1: from['x']* 20,
      y1: 400 - from['y'] * 20,
      x2: to['x'] * 20,
      y2: 400 - to['y'] * 20,
      style: { stroke: 'red' }
    )
  end

  graph = WeightedGraph::PositiveWeightedGraph.new

  connections.each do |connection|
    from_name = connection['from']
    from_pos = coordinates[from_name]
    to_name = connection['to']
    to_pos = coordinates[to_name]
    dist = Distance.between(from_pos, to_pos)
    graph.add_undirected_edge(from_name, to_name, dist)

    svg.text(dist.round(3),
      x: ((to_pos['x'] + from_pos['x'])/2) * 20,
      y: 400 - ((to_pos['y'] + from_pos['y'])/2) * 20,
      font_size: 20, fill: 'red'
    )
  end
  svg.save "segment#{segment}.svg"
  combined_svg << svg

  # create matrix containing only direct distances between nodes
  adjacency = Adjacency.new(nodes, graph)

  # create matrix containing shortes distances, possibly traversing other nodes
  pa = Path.new(nodes, graph)
  shortest = pa.floyd_warshall

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
