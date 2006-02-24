require 'container'

=begin
  * Name: Tile
  * Description
      Describes each tile of the map
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Tile < Container

  @@types = {
    :Floor      => {:walkable => true},
    :Trap       => {:walkable => true},
    :Wall       => {:walkable => false},
    :ClosedDoor => {:walkable => false},
    :Stair_up   => {:walkable => true},
    :Stair_down => {:walkable => true},
    :Column     => {:walkable => false},
    :Grass      => {:walkable => true},
    :Hill       => {:walkable => true},
    :Tree       => {:walkable => false},
    :Water      => {:walkable => false}
  }

  attr_reader :type, :action
  attr_writer :type, :action

  def initialize(type, action=nil)
    @type = type
    @action = action
  end

  ##
  # Returns true if the tile is walkable
  #
  def walkable?
    return @@types[@type][:walkable]
  end

  ##
  # Returns true if the tile has an action associated
  #
  def action?
    return @action!=nil
  end

  ##
  # Returns true if both tiles are of the same type
  #
  def ===(t)
    return self.type==t.type
  end

  def to_s
    return @type.to_s
  end
end
