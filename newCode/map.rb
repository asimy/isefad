require 'matriz'
require 'tile'
=begin
  * Name: Map
  * Description
      Mainly a group of tiles.
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Map

  ##
  # Class method that creates a random dungeon and returns it
  #
  def Map.create_random(w,h)
    map = Map.new(w,h)
    return map
  end

  def initialize(width, height, feed=Nil)
    @height= height
    @width = width
    @tiles = Matriz.new(@width, @height, Tile.new(:Wall))
    
    # This is the way to have always the same dungeon: feed it
    # with the same seed number. Therefore, to save a dungeon you just need
    # to save its seed.
    if feed
      srand(feed)
    end

    @rooms = Array.new
  end
end
