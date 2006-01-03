require 'matriz'
# This class provides with a random map

class Map

   # Defining the tiles
   
   Wall="#"
   Trans=255.chr # Transparent tile, never rendered to screen
   Dark=' '  # Opaque tile
   ClosedDoor="+"
   OpenDoor="'"
   Floor="."
   Solids=[Wall,ClosedDoor]
   
   def Map.isSolid?(what)
      return (Solids.index(what)!=nil)
   end
   
   def initialize(width, height, log)
      @height= height
      @width = width
      @m = Matriz.new(@width, @height, Wall)
      @log=log
      # srand(0) # This is the way to have always the same dungeon: feed it
      # with the same seed number. Therefore, to save a dungeon you just need
      # to save its seed.
      @rooms = Array.new
   end
   
   def w
      return @width
   end
   def h
      return @height
   end
   def m
      return @m
   end
   
   def create(elements)
      startx, starty = [4+rand(@width/2),4+rand(@height/2)]
      @m.ins_values(startx-1, starty-1 ,Matriz.new(3,3, Floor))
      keep_room(startx-1,starty-1,3,3, true)
      #Probabilities, on percentage, of having:
      room=20
      passage=65
      octroom=15
      max_tries=5000
      try=0
      
      elements.times do
         inserted=false
         while(!inserted && try<max_tries) do
            try=try+1
            i,j,d = search_wall
            dice=100-rand(100)
            is_room=true
            case dice
               when 0..room
                  x,y,w,h,mat = set_room(i,j,d)
               when room+1..room+passage
                  x,y,w,h,mat = set_passage(i,j,d)
                  is_room=false
               when room+passage+1..room+passage+octroom
                  x,y,w,h,mat = set_octroom(i,j,d)
            end
            if @m.empty?(x-1,y-1,w+1,h+1)
               if rand(2)==1 then @m[i,j]=Floor else @m[i,j]=ClosedDoor end
               @m.ins_values(x,y, mat)
               keep_room(x,y,w,h,is_room)
               inserted=true
            end
         end
      end
      return [startx, starty]
   end

   def set_room(i,j,d)
      w,h=[2+rand(7), 2+rand(7)]
      case d
         when 0
            x=i-w/2
            y=j-h
         when 1
            x=i+1
            y=j-h/2
         when 2
            x=i-w/2
            y=j+1
         when 3
            x=i-w
            y=j-h/2
      end
      return [x,y,w,h,Matriz.new(w,h,Floor)]
   end
   
   def set_octroom(i,j,d)
      w,h=7, 7
      case d
         when 0
            x=i-w/2
            y=j-h
         when 1
            x=i+1
            y=j-h/2
         when 2
            x=i-w/2
            y=j+1
         when 3
            x=i-w
            y=j-h/2
      end
      mat=Matriz.new(w,h,Floor)
      mat[0,0]=mat[0,1]=mat[1,0]=Wall
      mat[0,6]=mat[0,5]=mat[1,6]=Wall
      mat[6,0]=mat[6,1]=mat[5,0]=Wall
      mat[6,6]=mat[6,5]=mat[5,6]=Wall

      return [x,y,w,h,mat]
   end

   def set_passage(i,j,d)
      l=2+rand(12)
      case d
         when 0
            x=i
            w=w2=1
            y=j-l
            h=l
            h2=l-1
         when 1
            x=i+1
            w=l
            w2=l-1
            y=j
            h=h2=1
         when 2
            x=i
            w=w2=1
            y=j+1
            h=l
            h2=l-1
         when 3
            x=i-l
            w=l
            w2=w-1
            y=j
            h=h2=1
      end
      return [x,y,w2,h2,Matriz.new(w,h,Floor)]
   end
   
   def search_wall
      i,j = find_empty
      dir=rand(4)

      while @m[i,j]!=Wall
         dir=rand(4)
         case dir
	    when 0 then j=j-1
	    when 1 then i=i+1
	    when 2 then j=j+1
	    when 3 then i=i-1
	 end
      end
      return [i,j,dir]
   end

   # Registers the room, so we can find easily it later on
   def keep_room(x,y,w,h, room)
      @rooms << {'x'=>x,
                 'y'=>y,
                 'w'=>w,
                 'h'=>h,
                 'is_room'=>room
                }
   end

   # Returns an empty position on the map
   def find_empty(in_room=false)
      # First find a random room on the register
      r = @rooms[rand(@rooms.length)]
      if in_room
         while r['is_room'] do
            r = @rooms[rand(@rooms.length)]
         end
      end
      if r==nil then return [nil,nil] end
      
      # Then find a random spot on it
      i,j=[0,0]
      while @m[i,j]!=Floor
         i,j=[r['x']+rand(r['w']),r['y']+rand(r['h'])]
      end
      @log.info " Empty place: #{i},#{j} contains: #{@m[i,j]}"
      return [i,j]
   end

   # Tries to open a door
   def openDoor(x,y)
      @m[x,y]=OpenDoor
   end

   def clear?(x,y)
      return (not Map.isSolid?(@m[x,y]))
   end

   def value(x,y)
      return (@m[x,y])
   end

   def getbg(x,y)
      return @m[x,y]
   end
   
   def to_s
      return @m.to_s
   end
end
