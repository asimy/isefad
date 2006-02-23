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

    # Choose some initial empty place for the player
    begin
      x, y = [rand(map.width), rand(map.height)]
    end while(not empty?(x,y)) 
    @player = Player.new(self, x, y, 1, {"NAME"=>"Urgg"})
    CreatureGenerator.read('infos/monsters.info')
    @creatures = populate_map(@map, 10)

    @text_queue = Array.new
    self.message("Welcome to Isefad")
    
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
    ret &= !creature?(x,y)
    return ret
  end

  ##
  # Check for creatures in the cell.
  # Returns nil if none, the creature if any
  #
  def creature?(x,y)
    ret = nil
    if @player
      ret = @player if @player.x == x && @player.y == y
    end
    if @creatures
      @creatures.each do |c|
        ret = c if (c.x == x && c.y == y)
      end
    end
    return ret
  end

  ##
  # Stores a message in the queue, to be retrieved by the UI
  #
  def message(text)
    @text_queue.push text
  end

  ##
  # Pops a message from the queue to show up in the UI
  #
  def read_message
    return @text_queue.shift
  end

  ##4
  # Populates a map with a set of n random creatures
  # It returns an array of created creatures
  #
  def populate_map(map, n)
    ret = Array.new

    n.times do
      begin
        x, y = [rand(map.width), rand(map.height)]
      end while(not empty?(x,y)) 
      
      creat = CreatureGenerator.create_random(self, x, y)
      ret << creat
    end
    
    return ret
  end

  ##
  # Reomves a creature from the game
  #
  def kill(creat)
    message(creat.name+" is dead")
    @creatures.delete(creat)
  end
end
