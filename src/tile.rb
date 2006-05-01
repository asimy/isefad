require 'container'
require 'food'

=begin
  * Name: Tile
  * Description
      Describes each tile of the map
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Tile < Container
  include Food

  @@types = {
    :Floor      => {:walkable => true,  :eatable => false},
    :Trap       => {:walkable => true,  :eatable => false},
    :Wall       => {:walkable => false, :eatable => false},
    :ClosedDoor => {:walkable => false, :eatable => false},
    :Stair_up   => {:walkable => true,  :eatable => false},
    :Stair_down => {:walkable => true,  :eatable => false},
    :Column     => {:walkable => false, :eatable => false},
    :Grass      => {:walkable => true,  :eatable => true},
    :Hill       => {:walkable => true,  :eatable => true},
    :Tree       => {:walkable => false, :eatable => false},
    :Water      => {:walkable => false, :eatable => false}
  }

  attr_reader :type, :action
  attr_writer :type, :action

  def initialize(type, action=nil)
    @type = type
    @action = action
    
    if self.eatable?
      self.define_food(:veggie, 10)
    end
  end

  ##
  # Returns true if the tile is walkable
  #
  def walkable?
    return @@types[@type][:walkable]
  end
  
  ##
  # Returns true if the tile is eatable
  #
  def eatable?
    return @@types[@type][:eatable]
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
