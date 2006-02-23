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
end
