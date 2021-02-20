require 'minitest/autorun'
require_relative '../loader'

class TestLoader < MiniTest::Unit::TestCase
  def setup
    loader = Loader.new('coordinates.json', 'connections.json')

    @all_coordinates = loader.coordinates
    @all_connections = loader.connections
    @all_nodes = loader.nodes
  end

  def test_coordinates
    assert_equal(4, @all_coordinates.count)
    assert_equal(7, @all_coordinates.first.count)
  end

  def test_connections
    assert_equal(4, @all_connections.count)
    assert_equal(8, @all_connections.first.count)
  end

  def test_nodes
    assert_equal(['pof', 'a11', 'a12', 'a13', 'a14', 'a15', 'pow'], @all_nodes.first)
    assert_equal(['dsd', 'a41', 'a42', 'a43', 'a44', 'a45', 'cha'], @all_nodes.last)
  end

  def test_combination
    first_seg = @all_connections.first
    assert_equal('pof', first_seg.first['from']['name'])
    assert_equal(3, first_seg.first['from']['x'])
    assert_equal(5, first_seg.first['from']['y'])
  end
end
