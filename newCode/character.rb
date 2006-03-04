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

  attr_reader :ai, :x, :y, :speed
  attr_writer :ai

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

  ##
  # Move in given direction, at char current speed
  #
  def move_dir(dir)
    p_x = @x
    p_y = @y
    case dir
      when :up then p_y -= @speed
      when :left then p_x -= @speed
      when :down then p_y += @speed
      when :right then p_x += @speed
    end

    test = @game.empty?(p_x, p_y)
    
    if test
      @x = p_x
      @y = p_y
      @game.act(self, @x, @y) if self==@game.player
    else
      c = @game.creature?(p_x, p_y)
      if c
        @game.message("#{self.name} met #{c.name}")
      end
    end
  end
end
