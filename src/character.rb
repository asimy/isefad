require 'attributes'
require 'ai'
require 'container'

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

class Character < Container
  
  include Attributes

  attr_reader :ai, :x, :y, :speed, :target
  attr_writer :ai, :target

  def initialize(game, x, y, speed, attributes)
    @game = game
    @x = x
    @y = y
    @speed = speed
    self.attributes = attributes
  end

  ##
  # move directly to given position
  #
  def move_to(x, y)
    @x = x
    @y = y
  end

  def other_cell(dir, radius)
    p_x = @x
    p_y = @y
    case dir
      when :up then p_y -= radius
      when :left then p_x -= radius
      when :down then p_y += radius
      when :right then p_x += radius
    end
    return p_x, p_y
  end
  
  def next_cell(dir)
    return other_cell(dir, 1)
  end
  
  ##
  # Move in given direction, at char current speed
  #
  def move_dir(dir)

    p_x, p_y = other_cell(dir, @speed)
    
    test = @game.empty?(p_x, p_y) || @game.view == :world_map
    
    if test
      move_to(p_x, p_y)
      @game.act(self, @x, @y) if self==@game.player
    else
      c = @game.creature?(p_x, p_y)
      if c
        self.interact(c)
      end
    end
  end

  ##
  # What to do when the character meets another character.
  #
  def interact(c)
    @game.message("#{self.name}(#{self.strength}) met #{c.name}(#{c.health})")
    kill = c.attacked(self)
    @game.kill(c) if kill
  end
end
