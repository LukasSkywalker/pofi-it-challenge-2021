require 'minitest/autorun'
require_relative '../distance'
require 'weighted_graph'

class TestDistance < MiniTest::Unit::TestCase
  def setup
    nodes = ['A', 'B', 'C', 'D', 'E']

    graph = WeightedGraph::PositiveWeightedGraph.new
    graph.add_undirected_edge('A', 'B', 2)
    graph.add_undirected_edge('B', 'C', 2)
    graph.add_undirected_edge('C', 'D', 2)
    graph.add_undirected_edge('A', 'D', 10)
    graph.add_undirected_edge('B', 'E', 1)

    @adjacency = Adjacency.new(nodes, graph)
  end

  def test_between
    dist1 = Distance.between({'x' => 1, 'y' => 1}, {'x' => 4, 'y' => 5})
    assert_equal(5, dist1)

    dist2 = Distance.between({'x' => 4, 'y' => 5}, {'x' => 1, 'y' => 1})
    assert_equal(5, dist2)
  end
end
