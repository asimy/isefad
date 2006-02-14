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
  def Map.create_random(w, h, max_rooms=100)
    map = Map.new(w,h)

    # Select a starting point
    x = 1+random(w-2)
    y = 1+random(h-2)
    map.set_start(x, y)

    dir = Map.random_dir
    
    # Add the initial room
    room = Map.select_random_room(dir)
    map.add_room(x, y, room)
    
    # Try to add another #max_rooms random rooms
    max_rooms.times do
      x, y, dir = map.select_wall
      room = Map.select_random_room(dir)

      if map.check_space(x, y, room)
        map.add_room(x, y, room)
      end
      
    end
    
    return map
  end

  ##
  # Creates a random direction and returns it
  #
  def Map.random_dir
    case random(4)
      when 0 then return :up
      when 1 then return :left
      when 2 then return :down
      when 3 then return :right
    end
  end

  ##
  # Selects a random type of room, creates it, and returns it
  #
  def Map.select_random_room(dir)
  end

  ##
  # Here start the instance method declarations
  ##
  
  def initialize(width, height, seed=Nil)
    @height= height
    @width = width
    @tiles = Matriz.new(@width, @height, Tile.new(:Wall))
    
    # This is the way to have always the same dungeon: feed it
    # with the same seed number. Therefore, to save a dungeon you just need
    # to save its seed.
    if seed
      srand(seed)
    end

    @rooms = Array.new
  end
end
