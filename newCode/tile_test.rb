require 'test/unit'
require 'tile'

class TC_Tile < Test::Unit::TestCase

  def test_walkable
    tile = Tile.new(:Floor)
    assert(tile.walkable?)

    wall = Tile.new(:Wall)
    assert(!wall.walkable?)
  end
end
