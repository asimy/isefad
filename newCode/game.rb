require 'map_generator'
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
  # Check for an allowed move
  #
  def check_move(x, y)
    ret = @map[x,y] && @map[x,y].walkable?

    return ret
  end

end