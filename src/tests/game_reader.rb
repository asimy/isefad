=begin
  * Name: GameReader
  * Description:
     A Utility class to parse game description and create Game objects.
  * Author: phtrivier
  * Date: 25-10-06
  * Licence: GPL-2
=end

require 'game'
require 'dbc'

class GameReader
  include DesignByContract
  
  attr_accessor :map_description
  
  pre (:game, "game has been read") {@is_game_read}
  post(:game, "result is not nil") {|result| result != nil}
  attr_reader :game  

  post {not @is_game_read}
  def initialize
    @is_game_read = false
  end
  
  def game_read?
    return @is_game_read
  end
  
  def read_map
    # Je m'arrete volontairement
    # sur un test qui marche pas
    # Il faut tester le reste du code, en 
    # fait, avant de se lancer la dedans ...
# @is_game_read = true
# @game = Game.new    
  end
  
end
