=begin
  * Name: TileActions (Mixin)
  * Description
      Defines the different actions attachable to a Tile
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

module TileActions

  def go_up(char)
    map = change_map
    x = char.x
    y = map.height-2
    if map[x,y].walkable?
      @map = map
      char.move_to(x, y)
    end
  end
  
  def go_down(char)
    map = change_map
    x = char.x
    y = 1
    if map[x,y].walkable?
      @map = map
      char.move_to(x, y)
    end
  end
  
  def go_left(char)
    map = change_map
    x = map.width-2
    y = char.y
    if map[x,y].walkable?
      @map = map
      char.move_to(x, y)
    end
  end
  
  def go_right(char)
    map = change_map
    x = 1
    y = char.y
    if map[x,y].walkable?
      @map = map
      char.move_to(x, y)
    end
  end

end
