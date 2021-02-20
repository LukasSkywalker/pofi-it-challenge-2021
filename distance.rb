# Calculates shortest distance in a graph by visiting all nodes.
# Permutes the order in which the nodes are visisted and takes
# the shortest path to the next node in the list, possibly revisiting
# older nodes.

class Distance
  attr_reader :nodes, :adjacency
  def initialize(nodes, adjacency)
    @nodes = nodes
    @adjacency = adjacency
  end

  # Calculates the distance between two points in a 2d cartesian system
  def self.between(a, b)
    dx = b['x'] - a['x']
    dy = b['y'] - a['y']
    Math.sqrt(dx**2 + dy**2)
  end

  # Get the nodes traversed by the shortest path
  def shortest_path
    distances.min_by(&:last).first
  end

  # Get the distance of the shortest path
  def shortest_distance
    distances.min_by(&:last).last
  end

  def to_s
    distances.inspect
  end

  private

  def distances
    results = {}
    valid_permutations.each do |permutation|
      distance = 0
      permutation.each_cons(2) do |from, to|
        distance += adjacency.get(from, to)
      end
      results[permutation.join('-')] = distance
    end
    return results
  end

  def valid_permutations
    nodes.permutation.select do |perm|
      perm.first == nodes.first && perm.last == nodes.last
    end
  end
end
