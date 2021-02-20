require 'minitest/autorun'
require_relative '../adjacency'
require 'weighted_graph'

class TestAdjacency < MiniTest::Unit::TestCase
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

  def test_init
    assert_equal(0, @adjacency.matrix[0][0])
    assert_equal(2, @adjacency.matrix[0][1])
    assert_equal(2, @adjacency.matrix[1][2])
    assert_equal(2, @adjacency.matrix[2][3])
    assert_equal(10, @adjacency.matrix[0][3])
    assert_equal(1, @adjacency.matrix[1][4])
  end

  def test_get
    assert_equal(0, @adjacency.get('A', 'A'))
    assert_equal(2, @adjacency.get('A', 'B'))
    assert_equal(10, @adjacency.get('A', 'D'))
    assert_equal(1, @adjacency.get('B', 'E'))
  end

  def test_set
    assert_equal(10, @adjacency.get('A', 'D'))
    @adjacency.set('A', 'D', 5)
    assert_equal(5, @adjacency.get('A', 'D'))
  end

  def test_clone
    @adjacency.set('A', 'D', 5)
    assert_equal(5, @adjacency.get('A', 'D'))

    copy = @adjacency.clone

    assert_equal(5, @adjacency.get('A', 'D'))
    assert_equal(5, copy.get('A', 'D'))

    @adjacency.set('A', 'D', 3)

    assert_equal(3, @adjacency.get('A', 'D'))
    assert_equal(5, copy.get('A', 'D'))
  end
end
