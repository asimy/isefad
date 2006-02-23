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

  attr_reader :pix
  def initialize(game, x, y, speed, ai, attributes)
    super(game, x, y, speed, attributes)
    self.ai = ai

    @pix = attributes["PX"]
  end

  ##
  # Sets the ai to call each turn
  #
  def ai=(ai)
    @ai = ("update_"+ai.downcase).intern
  end

  ##
  # Does everything the creature needs to do each turn
  #
  def update(map)
    if(!self.take_age)
      # die
      @game.kill(self)
    end
    AI.send(@ai, self, map)
  end
end
