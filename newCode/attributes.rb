=begin
  * Name: Attributes (Mixin)
  * Description
      Describe the game attributes and how to interact with them
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

module Attributes

  @attributes = {
    :max_health => 100,
    :health => 100,
    :strength => 4,
    :agility => 2
  }

  ##
  # Setter
  #
  def attributes= (atts)
    @attributes = atts.dup
  end

  ##
  # Getters
  #
  def health
    return @attributes[:health]
  end
  def max_health
    return @attributes[:max_health]
  end
  def strength
    return @attributes[:strength]
  end
  def agility
    return @attributes[:agility]
  end
  #
  ##

  ##
  # Method that calculates an attack against us
  # by another set of attributes
  # Returns true if we die, false otherwise
  #
  def attacked(attacker)
    attack = random(2+attacker[:strength])-random(self.agility)
    if attack>0
      @attributes[:health] -= attack
    end
    if self.health <= 0
      return true
    else 
      return false
    end
  end

  ##
  # Gets h more life points
  #
  def heal(h)
    if self.health+h > self.max_health
      @attributes[:health] = @attibutes[:max_health]
    else
      @attributes[:health] += h
    end
  end
end
