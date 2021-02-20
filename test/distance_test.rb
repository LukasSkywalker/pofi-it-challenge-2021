require 'minitest/autorun'
require_relative '../distance'

class TestDistance < MiniTest::Unit::TestCase

  def test_between
    dist1 = Distance.between({'x' => 1, 'y' => 1}, {'x' => 4, 'y' => 5})
    assert_equal(5, dist1)

    dist2 = Distance.between({'x' => 4, 'y' => 5}, {'x' => 1, 'y' => 1})
    assert_equal(5, dist2)
  end
end
