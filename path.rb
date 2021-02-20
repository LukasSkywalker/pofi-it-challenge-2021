# Calculates shortest distance between all pairs of nodes
# using the Floyd-Warshall algorithm.

class Path
  attr_accessor :nodes, :graph

  def initialize(nodes, graph)
    @nodes = nodes
    @graph = graph
  end

  # Calculate the shortest distance between each pair of nodes
  def floyd_warshall
    matrices = [Adjacency.new(nodes, graph)]
    nodes.each_with_index do |iter, k|
      matrices[k] = matrices[k-1].clone
      nodes.each_with_index do |from, i|
        nodes.each_with_index do |to, j|
          prev = matrices[k-1]
          dist = [prev.get(from, to), prev.get(from, iter) + prev.get(iter, to)].min
          matrices[k].set(from, to, dist)
        end
      end
    end
    return matrices.last
  end
end
