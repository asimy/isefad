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
    :Tree       => {:walkable => false},
    :Water      => {:walkable => false}
  }

  attr_reader :type, :app_type

  def initialize(type, apparent_type=nil)
    @type = type
    @app_type=apparent_type
  end

  ##
  # Returns true if the tile is walkable
  #
  def walkable?
    return @@types[@type][:walkable]
  end

  ##
  # Returns true if the tile is hidden (has different
  # apparent and real types)
  #
  def hidden?
    return @app_type!=nil
  end

  ##
  # Returns true if both tiles are of the same type
  #
  def ===(t)
    return self.type==t.type
  end

  def to_s
    if @app_type
      return @app_type.to_s
    else
      return @type.to_s
    end
  end
end
