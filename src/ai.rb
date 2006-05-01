=begin
  * Name: AI
  * Description
      Contains all AI.update<type> methods.
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class AI
  def AI.update_none(char, map)
  end

  def AI.update_random(char, map)
    case rand(4)
      when 0 then char.move_dir(:up)
      when 1 then char.move_dir(:left)
      when 2 then char.move_dir(:down)
      when 3 then char.move_dir(:right)
    end
  end

  ##
  # This AI looks for the closest wwaker creature and 
  # hunts it down, then eats it.
  #
  def AI.update_hunt(char, map)
      AI.update_random(char, map)
  end

  ##
  # This AI looks for grass to eat.
  #
  def AI.update_grass(char, map)
    if map[char.x, char.y].eatable?
      char.eat(map[char.x, char.y])
    else
      AI.update_random(char, map)
    end
    if !char.hungry?
      char.ai="random"
    end
  end
  
end
