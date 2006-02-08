require 'character'
# This class contains Player data and methods

class Player < Character
   def initialize(x,y,map, log)
      super(x,y,map,log)
      @char='@'
   end
   
   def move(dir, map)
      tx=@x
      ty=@y
      case dir
         when :up then ty=ty-1
         when :left then tx=tx+1
         when :down then ty=ty+1  
         when :right then tx=tx-1
      end
      if map.clear?(tx,ty) then move_to(tx,ty, map) end
      #If door, try to open it
      if map.value(tx,ty)=='+'
         map.openDoor(tx,ty)
         update(map)
      end
   end
end
