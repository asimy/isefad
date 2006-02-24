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

class WorldMap
  
  attr_reader :height, :width
  
  def initialize(w,h)
    @world = Matriz.new(w, h, {})
    w.times do |i|
      h.times do |j|
        @world[i,j] = {
          :seed = rand,
          :type = "field",
          :w = 40 + rand(100),
          :h = 10 + rand(100)
        }
      end
    end
  end

  def current=(x,y)
    @x = x
    @y = y
  end
  
  def current
    creator = ("create_"+@world[x,y]).intern
    
    MapGenerator.send(creator,
                      @world[x,y][:w],
                      @world[x,y][:h],
                      @world[x,y][:seed])
  end

  def go_up
    @y -= 1
  end
  def go_left
    @x -= 1
  end
  def go_down
    @y += 1
  end
  def go_right
    @x += 1
  end
end
 
