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
  
  ##
  # Map description in the game_reader format.
  #
  attr_accessor :map_description

  ##
  # Last previously read game.
  #
  pre(:game, "game has been read") {@is_game_read}
  post(:game, "result is not nil") {|result| result != nil}
  attr_reader :game  

  ##
  # Constructor.
  #
  post {not @is_game_read}
  def initialize
    @is_game_read = false
  end
  
  ##
  # Has a game been successfully read ?
  #
  def game_read?
    return @is_game_read
  end

  ##
  # Read a game from the description
  #
  pre("map has been described") {@map_description != nil}
  pre("map is valid"){is_map_description_valid?} 
  def read_game
    # Je m'arrete volontairement
    # sur un test qui marche pas
    # Il faut tester le reste du code, en 
    # fait, avant de se lancer la dedans ...
    @is_game_read = true
    @game = Game.new
    # The heigth of the map is the number of elements
    # in the description, and the width is the maximum
    # length of these descriptions.
    h = @map_description.length
    w = @map_description.collect{|l| l.size }.max
    @game.map = Map.new(w,h, {}) 
                        
    # Now read the elements one by one and add items
    # to the map accordingly
    @map_description.each_with_index do |line, y|
      x = 0
      line.each_byte do |c|
        read_tile(x,y,c)
        x = x + 1
      end
    end

  end
  
  ##
  # Read a character as a tile
  #
  pre("map exists") {@game.map != nil}
  pre("position is valid") { |x,y,tile| @game.map.inside?(x,y)}
  pre("character is provided") {|x,y,tile| tile != nil}
  def read_tile(x,y,tile)
    case tile
    when '.'[0]
      @game.map[x,y] = :Grass 
    end     
  end 

  ##
  # Does the map description only contains valid chars ? 
  #
  pre("map has been described") {@map_description != nil}
  def is_map_description_valid?
    return @map_description.each do |c|
      return (not is_tile_description?(c))
    end
  end 

  ##
  # Is a character a valid tile description ? 
  #
  pre("not null") {|c| c!=nil}
  def is_tile_description?(c)
    return ['.', '@'].include?(c)
  end

end
