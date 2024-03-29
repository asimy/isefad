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
    
    if self.hungry?
      if self.carnivore
        self.ai="hunt" 
      else
        self.ai="grass"
      end
    end
    
  end

  ##
  # Is this creature friendly to the player?
  # PLACEHODER
  #
  def friendly?
    return false
  end

  ##
  # Interact with another character
  #
  def interact(c)
    if self.name == c.name && self.sex != c.sex
      if self.fertile? && c.fertile?
        if rand(4) > -1
          #reproduce
          if $log
            $log.debug "#{self.name} tries to have sex with #{c.name}"
          end
          @game.add_creature(self.name, self.x, self.y)
          self.enter_infertility
          c.enter_infertility
        end
      end
    end
    if $log
      $log.debug "#{self.sex} #{self.name} has met #{c.sex} #{c.name}"
    end
  end
end
