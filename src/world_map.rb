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
  
  def initialize(w,h)
    @world = Matriz.new(w, h, {})
    w.times do |i|
      h.times do |j|
        @world[i,j] = {
          :seed => rand,
          :type => "worldmap",
          :w => 40 + rand(100),
          :h => 10 + rand(100),
          :creatures => nil
        }
      end
    end
    @height = h
    @width = w
  end

  def creatures
    return @world[@x,@y][:creatures]
  end
  
  def creatures= (creats)
    @world[@x,@y][:creatures] = creats
  end

  def current=(xy)
    @x = xy[0]
    @y = xy[1]
  end
  
  def current
    creator = ("create_"+@world[@x,@y][:type]).intern
    
    MapGenerator.add_map_switchers!(
      MapGenerator.send(creator,
                        @world[@x,@y][:w],
                        @world[@x,@y][:h],
                        @world[@x,@y][:seed])
      )

  end

  def go_up
    @y -= 1 if @y>0
  end
  def go_left
    @x -= 1 if @x>0
  end
  def go_down
    @y += 1 if @y<@world.h-1
  end
  def go_right
    @x += 1 if @x<@world.w-1
  end
end
 
