require 'character'

=begin
  * Name: Creature
  * Description
        Extends the Character to add some 'creature-only' features
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Creature < Character

  def initialize(game, x, y, speed, ai, attributes)
    super(game, x, y, speed, attributes)
    set_ai(ai)
  end

  ##
  # Sets the ai to call each turn
  #
  def set_ai(ai)
    @ai = ("update_"+ai.downcase).intern
  end

  ##
  # Does everything the creature needs to do each turn
  #
  def update(map)
    if(!self.take_age)
      # die
      #self = nil
    end
    AI.send(@ai, self, map)
  end
end
