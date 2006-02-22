require 'attributes'
require 'ai'

# Let's load all 'ai_<something>' files in directory to enable exansion sets
Dir['ai/ai_*.rb'].each {|ai| require ai}

=begin
  * Name: Character
  * Description
      Describes any game living being. Creatures, NPCs and player
      should inherit from this one.
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Character
  
  include Attributes

  attr_reader :ai, :x, :y, :speed
  attr_writer :ai

  def initialize(x, y, speed, ai, attributes)
    @x = x
    @y = y
    @speed = speed
    @ai = ("update_"+ai.to_lower).intern
    self.attributes = attributes
  end

  ##
  # move directly to given position
  #
  def move_to(x, y)
    @x = x
    @y = y
  end

  ##
  # Move in given direction, at char current speed
  #
  def move_dir(dir)
    case dir
      when :up then @y -= @speed
      when :left then @x -= @speed
      when :down then @y += @speed
      when :right then @x += @speed
    end
  end

  def update(map)
    if(!self.take_age)
      # die
      #self = nil
    end
    AI.send(@ai, self, map)
  end
end
