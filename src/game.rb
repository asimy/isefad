require 'map_generator'
require 'creature_generator'
require 'creature'
require 'player'
require 'tile_actions'
require 'world_map'
require 'creature_repartition'
require 'directions'

=begin
  * Name: Game
  * Description
      Game logics, game loop, game variables...
  * Author: elKano
  * Date: 20-02-06
  * License: GPL-2
=end

class Game

  include TileActions

  ##
  # player: contains the 'player' instance,
  # creatures: contains an array of 'creature' instances
  # map: contains the current map to show, a map instance
  # world_map: contains the global map
  # view: contains one of {:world_map, :current_map}
  attr_accessor :player, :creatures, :map, :world_map, :view

  def initialize
    
    #Some random attributes for developping.
    atts = {"NAME" => "Urgg",
            "HP" => 20,
            "ST" => 4,
            "AG" => 3
           }
           
    @world_map = MapGenerator.create_worldmap(100,80)

    @view = :current_map

    CreatureGenerator.read('infos/creatures.info')

    change_map(50,50)

    # Choose some initial empty place for the player
    begin
      x, y = [rand(map.width), rand(map.height)]
    end while(not empty?(x,y)) 

    @player = Player.new(self, -1, -1, 1, atts)
    @player.move_to(x,y)

    @text_queue = Array.new
    self.message("Welcome to Isefad")

    @time = 0
    
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
    @time += 1
  end
  
  ##
  # Check for an allowed tile in 'map'
  #
  def empty?(x, y, map=@map)
    ret = map[x,y] && map[x,y].walkable?
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
  # Checks for actions on the tile,
  # and executes them
  #
  def act(char, x, y)
    if @map[x,y] && @map[x,y].action
      $log.debug("Action: #{@map[x,y].action}") if $log
      self.send(@map[x,y].action, char)
    end
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

  ##
  # Populates a map with a set of n random creatures
  # It returns an array of created creatures
  #
  def populate_map(map, n)
    ret = Array.new

    n.times do
      begin
        x, y = [rand(map.width), rand(map.height)]
      end while(not empty?(x,y,map)) 
      
      creat = CreatureGenerator.create_random(self, x, y)
      ret << creat
    end
    
    return ret
  end

  ##
  # Adds a new creature to the game, on the current map
  #
  def add_creature(name, x, y, sex=nil)
    case rand(2)
      when 0 then sex = :M
      when 1 then sex = :F
    end unless sex
    creat = CreatureGenerator.create(self, name, x, y, sex)

    @creatures << creat
  end

  ##
  # Removes a creature from the game
  #
  def kill(creat)
    $log.debug(creat.name+" is dead") if $log
    creat.give_all(@map[creat.x, creat.y])
    @creatures.delete(creat)
  end

  ##
  # Changes the current view
  #
  def switch_view(what=nil)
    $log.debug("before: "+@view.to_s) if $log
    if what == nil
      case @view
      when :world_map
        @view = :current_map
        change_map(@player.x, @player.y)

        @player.move_to(@map.width/2,3)
      when :current_map
        @view = :world_map
        @map = @world_map
        @player.move_to(@world_map.x, @world_map.y)
        @creatures = []
      end
    end
    $log.debug("after: "+@view.to_s) if $log
  end

  ##
  # Changes the current map
  #
  def change_map(i, j)
    
    @world_map.current = [i,j]
    @map = @world_map.current
    if !@world_map.creatures
      rep = CreatureRepartition.create_random(
          @time,
          CreatureGenerator.names,
          20
        )
      @world_map.creatures = rep
    else
      @world_map.creatures.evolve!(@time)
    end
    
    @creatures = @world_map.creatures.populate(self, @map)

  end

  ##
  # Assuming there  and is this creature friendly ? 
  def friendly?(dir)
    px, py = @player.next_cell(dir)
    return creature?(px,py)
  end

  def any_friendly?
    return Directions::All.find do |dir|
      friendly?(dir)
    end
  end
  
  def chat(dir)
    message("You would be chatting with someone")    
  end
  
end
