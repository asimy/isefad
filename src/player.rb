require 'character'

=begin
  * Name: Player
  * Description
      The Player class
  * Author: elKano
  * Date: 22-02-06
  * License: GPL-2
=end

class Player < Character
  def initialize(game, x, y, speed, attributes)
    super(game, x, y, speed, attributes)
  end

  ##
  # Enters the current square if possible
  # ex: go into the current map, go down a tunnel
  #
  def go_in
    case @game.view
    when :world_map
      @game.switch_view
    end
  end

  ##
  # Same as go_in but reverse way :)
  #
  def go_out
    case @game.view
    when :current_map
      @game.switch_view
    end
  end
end
