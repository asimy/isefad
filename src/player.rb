require 'character'

=begin
  * Name: Player
  * Description
      The Player class
  * Author: elKano
  * Date: 22-02-06
  * License: GPL-2
=end

class Player < Character

  def initialize(game, x, y, speed, attributes)
    super(game, x, y, speed, attributes)

    @memory = Hash.new # A hash of memories of what the player has seen

    @vision = 4 # the viewing distance
  end

  ##
  # Enters the current square if possible
  # ex: go into the current map, go down a tunnel
  #
  def go_in
    case @game.view
    when :world_map
      @game.switch_view
#      @current_memory = @game.world_map.current_seed
    end
  end

  ##
  # Same as go_in but reverse way :)
  #
  def go_out
    case @game.view
    when :current_map
      @game.switch_view
#      @current_memory = :world_map
    end
  end

  ##
  # Returns the current memory
  #
  def memory
    case @game.view
    when :world_map
      current_memory = :world_map
    when :current_map
      current_memory = @game.world_map.current_seed
    end
    
    if !@memory[current_memory]
      map = @game.map
      @memory[current_memory] = Matriz.new(map.width, map.height, false) 
    end

    return @memory[current_memory]
  end

  ##
  # Let's redefine move_to to include FoV
  #
  def move_to(x, y)
    super(x, y)
    update_memory!(self.memory)
  end

  ##
  # update_memory is the method that actually calculates what's seen and what not
  #
  def update_memory!(mem)
    map = @game.map
      
    x_s = @x-@vision
    y_s = @y-@vision
    @fov = linecast(map.tiles.get_values(x_s,y_s,2*@vision,2*@vision))
    mem.ins_values(x_s, y_s, @fov, false)
  end


  def linecast(map_piece)
    cx=cy=@vision # The char coordinates in the Field of Vision
    sees=Matriz.new(map_piece.w, map_piece.h, false)
    # This works because fov and sees are actually squares
    for i in 0...map_piece.w do
      launch_ray(cx,cy, i,0, sees, map_piece)
      launch_ray(cx,cy, i,map_piece.h, sees, map_piece)
      launch_ray(cx,cy, 0,i, sees, map_piece)
      launch_ray(cx,cy, map_piece.w,i, sees, map_piece)
    end
    return sees
  end

  #Launches a ray from (ix,iy) to (tx,ty) on fov and updates sees accordingly
  def launch_ray(ix,iy, tx,ty,sees,fov)
    dx=(tx-ix).to_f/@vision.to_f
    dy=(ty-iy).to_f/@vision.to_f
    cx=ix.to_f
    cy=iy.to_f
    x_list=[]
    y_list=[]
    while (cx-tx).abs>dx.abs || (cy-ty).abs>dy.abs do
      cx=cx+dx
      cy=cy+dy
      x_list << cx
      y_list << cy
    end
    i=0
    go_on=true # Can we continue the ray?
    while i<x_list.length && go_on do
      cx=x_list[i]+0.5
      cy=y_list[i]+0.5
      what = fov[cx, cy]
      if(what!=nil)
        sees[cx, cy] = true
        if what.respond_to?(:walkable?)
          if !what.walkable? then go_on=false end
        else 
          if what[:tile].respond_to?(:walkable?) && !what[:tile].walkable? then go_on=false end
        end
      end
      i=i+1
    end
  end
end
