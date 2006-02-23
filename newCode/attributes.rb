=begin
  * Name: Attributes (Mixin)
  * Description
      Describe the game attributes and how to interact with them
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

module Attributes

  attr_reader :name,
              :max_health,
              :health,
              :strength,
              :agility,
              :max_age,
              :age

  ##
  # Setter
  #
  def attributes= (atts)
    @name = atts["NAME"]
    @max_health = atts["HP"]
    @health = atts["HP"]
    @streght = atts["ST"]
    @agility = atts["AG"]
    @max_age = atts["MA"]
    @age = atts["AGE"]
  end

  ##
  # Method that calculates an attack against us
  # by another set of attributes
  # Returns true if we die, false otherwise
  #
  def attacked(attacker)
    attack = rand(2+attacker.strength)-rand(@agility)
    if attack>0
      @health -= attack
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
    if @health+h > @max_health
      @health = @max_health
    else
      @health += h
    end
  end

  ##
  # Adds an age unit to the creature. When it's too young or old, it
  # should not be a very good fighter. During it's post-puberty, it
  # may try to reproduce. If it grows too old, it will die.
  # Returns false if it dies, true otherwise
  #
  def take_age
    @age += 1
    if @age > @max_age
      return false
    end

    return true
  end
end
