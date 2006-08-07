require 'matriz'
require 'map'
=begin
  * Name: WorldMap
  * Description
      It's a group of maps, effectively defining the world
  * Author: elKano
  * Date: 24-02-06
  * License: GPL-2
=end

class WorldMap < Map
  
  attr_reader :height, :width
  attr_accessor :x, :y
  
  def initialize(w,h)
    @tiles = Matriz.new(w, h, {})
    w.times do |i|
      h.times do |j|
        @tiles[i,j] = {
          :seed => rand,
          :tile => Tile.new(:Grass),
          :w => 80,
          :h => 40,
          :creatures => nil
        }
      end
    end
    @height = h
    @width = w
  end

  def creatures
    return @tiles[@x,@y][:creatures]
  end
  
  def creatures= (creats)
    @tiles[@x,@y][:creatures] = creats
  end

  def current=(xy)
    @x = xy[0]
    @y = xy[1]
  end
  
  def current
    #creator = ("create_"+@tiles[@x,@y][:type]).intern
    case @tiles[@x, @y][:tile]
    when :Grass, :Hill
      creator = :create_field
    when :Tree
      creator = :create_forest
    else
      creator = :create_field
    end
    
    MapGenerator.add_map_switchers!(
      MapGenerator.send(creator,
                        @tiles[@x,@y][:w],
                        @tiles[@x,@y][:h],
                        @tiles[@x,@y][:seed])
      )

  end

  def []=(x, y, what)
    @tiles[x,y][:tile] = Tile.new(what) if @tiles[x,y]
  end

  def [](x,y)
    @tiles[x,y][:tile] if @tiles[x,y]
  end

  def go_up
    @y -= 1 if @y>0
  end
  def go_left
    @x -= 1 if @x>0
  end
  def go_down
    @y += 1 if @y<@tiles.h-1
  end
  def go_right
    @x += 1 if @x<@tiles.w-1
  end
end
 
