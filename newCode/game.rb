require 'map_generator'
require 'creature_generator'
require 'creature'
require 'player'

=begin
  * Name: Game
  * Description
      Game logics, game loop, game variables...
  * Author: elKano
  * Date: 20-02-06
  * License: GPL-2
=end

class Game

  attr_accessor :player, :creatures, :map

  def initialize
    @map = MapGenerator.create_field(80, 40, 100, true)
    @player = Player.new(self, 10, 10, 1, '')
    CreatureGenerator.read('infos/monsters.info')
    @creatures = populate_map(@map, 10)
  end

  ##
  # Calls the 'update' methods of all ai's in game
  #
  def update
    @creatures.each { |c| c.update(@map) }
  end
  
  ##
  # Does one iteration of the loop
  #
  def iterate
    self.update
  end
  
  ##
  # Check for an allowed tile
  #
  def empty?(x, y)
    ret = @map[x,y] && @map[x,y].walkable?
    if @creatures
      @creatures.each do |c|
        ret &= !(c.x == x && c.y == y)
      end
    end
    return ret
  end

  ##
  # Populates a map with a set of n random creatures
  # It returns an array of created creatures
  #
  def populate_map(map, n)
    ret = Array.new

    n.times do
      x, y = rand(map.width), rand(map.height)
      
      while(not empty?(x,y)) 
        x, y = [rand(map.width), rand(map.height)]
      end
      
      creat = CreatureGenerator.create_random(self, x, y)
      ret << creat
    end
    
    return ret
  end
end
