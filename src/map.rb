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
  
  include Enumerable

  attr_reader :height, :width, :tiles
  def initialize(width, height, filler)
    @height= height
    @width = width
    @tiles = Matriz.new(@width, @height, filler)
    @register = Array.new # Register of map rooms
    
    @rooms = Array.new
  end

  def [](x,y)
    return @tiles[x,y]
  end

  def set_start(x,y)
    @start = [x,y]
  end

  def []=(x, y, type)
    @tiles[x,y] = Tile.new(type)
  end
  
  def add_room(x, y, room)
    @tiles.ins_values(x, y, room)
    @register << [x, y, room.w, room.h]
  end

  def select_wall
    # Find a random room in the register
    r = @register[rand(@register.length)]
    # find a Floor spot
    x, y = r[0]+rand(r[2]), r[1]+rand(r[3])
    while @tiles[x, y].type != :Floor do
      x, y = r[0]+rand(r[2]), r[1]+rand(r[3])
    end

    # now find a wall
    dir = MapGenerator.random_dir
    while @tiles[x, y].type != :Wall do
      case dir
        when :up then y-= 1
        when :left then x -= 1
        when :down then y += 1
        when :right then x += 1
      end
    end
    
    return x, y, dir
  end

  ##
  # Checks that the given element can fit in the map
  #
  def check_space(x,y,r,bg)
    return @tiles.fits(x,y,r,bg)
  end

  ##
  # Is a position inside this map ?
  #
  def inside?(x,y)
    if (x < 0 or y < 0) then return false end
    if (x > @width or y > @height) then return false end
    return true      
  end
  
  def to_s
    @height.times do |j|
      @width.times do |i|
        case @tiles[i,j].type
          when :Wall then print '#'
          when :Floor then print '.'
          when :ClosedDoor then print '+'
          when :Grass then print '.'
          when :Hill then print ':'
          when :Tree then print 'T'
          when :Water then print '='
          else print '@'
        end
      end
      print "\n"
    end
  end

  ##
  # Yields every tile in left to right, top
  # to bottom order, with indexes.
  #
  def each_with_x_y(&block)
    @tiles.each_with_indexes(block)
  end

  ##
  # Yields every tile in left to right, top
  # to bottom order. (used for Enumerable purposes)
  #
  def each(&block)
    @tiles.each(block)
  end

end
