class Distance
  attr_reader :nodes, :adjacency
  def initialize(nodes, adjacency)
    @nodes = nodes
    @adjacency = adjacency
  end

  def self.between(a, b)
    dx = b['x'] - a['x']
    dy = b['y'] - a['y']
    Math.sqrt(dx**2 + dy**2)
  end

  def shortest_path
    distances.min_by(&:last).first
  end

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
