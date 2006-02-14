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
    :Stair_up   => {:walkable => true},
    :Stair_down => {:walkable => true},
    :Column     => {:walkable => false}
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
end
