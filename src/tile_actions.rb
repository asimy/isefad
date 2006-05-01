=begin
  * Name: TileActions (Mixin)
  * Description
      Defines the different actions attachable to a Tile
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

module TileActions

  def now_go(char, map, x, y)

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
    
    creatures = @world_map.creatures.populate(self, map)
    if map[x,y].walkable?
      @map = map
      @creatures = creatures
      char.move_to(x, y)
    end
  end
  
  def go_up(char)
    @world_map.go_up
    map = @world_map.current
    x = char.x
    y = map.height-2
    
    now_go(char, map, x, y)
  end
  
  def go_down(char)
    @world_map.go_down
    map = @world_map.current
    x = char.x
    y = 1
    
    now_go(char, map, x, y)
  end
  
  def go_left(char)
    @world_map.go_left
    map = @world_map.current
    x = map.width-2
    y = char.y
    
    now_go(char, map, x, y)
  end
  
  def go_right(char)
    @world_map.go_right
    map = @world_map.current
    x = 1
    y = char.y
    
    now_go(char, map, x, y)
  end
end
