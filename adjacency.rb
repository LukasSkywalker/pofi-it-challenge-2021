# Generates an adjacency matrix from a list of nodes and their connecting edges.
# Getters and setters for individual entries.

class Adjacency
  attr_reader :nodes, :graph, :matrix
  def initialize(nodes, graph, matrix = nil)
    @nodes = nodes
    @graph = graph
    if matrix.nil?
      @matrix = []
      init_matrix
    else
      @matrix = matrix
    end
  end

  # Get the distance between the two given nodes
  def get(from, to)
    fi = nodes.index(from)
    ti = nodes.index(to)
    matrix[fi][ti]
  end

  # Set the distance between the two given nodes
  def set(from, to, value)
    fi = nodes.index(from)
    ti = nodes.index(to)
    matrix[fi][ti] = value
  end

  def to_s
    str = " \t" + nodes.join("\t") + "\n"
    nodes.each do |from|
      str += from
      nodes.each do |to|
        str += "\t#{get(from, to)}"
      end
      str += "\n"
    end
    return str
  end

  # Copy an existing matrix
  def clone
    Adjacency.new(nodes, graph, Marshal.load(Marshal.dump(matrix)))
  end

  private

  def init_matrix
    nodes.each_with_index do |from, fi|
      matrix[fi] = []
      nodes.each_with_index do |to, ti|
        matrix[fi] << get_distance(from, to)
      end
    end
  end

  def get_distance(from, to)
    return 0 if from == to
    return 999999 if !graph.contains_edge?(from, to)
    return graph.get_edge_weight(from, to)
  end
end
