# Class from which inherit all characters in the game:
#  the player, the monsters, and the NPCs

class Character
   def initialize(x,y,map, log)
      @x=x
      @y=y
      @vision=5
      @log=log
      # The current map as the character knows it
      @map = Matriz.new(map.w, map.h, Map::Trans)
      @char= '$'
      move_to(x,y,map)
   end
   
   def move(dir, map)
      tx=@x
      ty=@y
      case dir
         when 0 then ty=ty-1
	 when 1 then tx=tx+1
	 when 2 then ty=ty+1  
	 when 3 then tx=tx-1
      end
      if map.clear?(tx,ty) then move_to(tx,ty, map) end
   end

   def move_to(tx,ty, map)
      @oldbg=map.getbg(@x,@y)
      @oldx=@x
      @oldy=@y
      @x=tx
      @y=ty
      update(map)
   end

   def update(map)
      # Update known map with field of vision
      x_s = @x-@vision
      y_s = @y-@vision
      @fov = linecast(map.m.get_values(x_s,y_s,2*@vision,2*@vision))
      @map.ins_values(x_s, y_s, @fov)
   end

   def linecast(fov)
      cx=cy=@vision # The char coordinates in the Field of Vision
      sees=Matriz.new(fov.w, fov.h, Map::Trans)
      # This works because fov and sees are actually squares
      for i in 0...fov.w do
         launch_ray(cx,cy, i,0,sees,fov)
         launch_ray(cx,cy, i,fov.h, sees, fov)
         launch_ray(cx,cy, 0,i,sees,fov)
         launch_ray(cx,cy, fov.w,i, sees, fov)
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
      goon=true # Can we continue the ray?
      while i<x_list.length && goon do
         cx=x_list[i]+0.5
         cy=y_list[i]+0.5
         what = fov[cx, cy]
         if(what!=nil)
            sees[cx, cy]=what 
            if Map.isSolid?(what) then goon=false end
         end
         i=i+1
      end
   end

   def oldpos
      return [@oldx, @oldy, @oldbg]
   end

   def pos
      return [@x, @y, @char]
   end

   def map
      return @map
   end
   def fov
      return @fov
   end
   def fovpos
      return [@x-@vision, @y-@vision]
   end

end
