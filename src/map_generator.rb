require 'map'
require 'tile'
=begin
  * Name: MapGenerator
  * Description
      Collection of Class Methods creating maps
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class MapGenerator

  ##
  # Class method that creates a random dungeon and returns it
  #
  def MapGenerator.create_dungeon(w, h, seed=nil, max_rooms=w*h)
    map = Map.new(w,h,Tile.new(:Wall))
    srand(seed) if seed

    # Select a starting point
    x = 5+rand(w-10)
    y = 5+rand(h-10)
    map.set_start(x, y)

    dir = MapGenerator.random_dir
    
    # Add the initial room
    dx, dy, room, mask = MapGenerator.select_random_room(dir)
    map.add_room(x-dx, y-dy, room)
    
    # Try to add another #max_rooms random rooms
    max_rooms.times do
      x, y, dir = map.select_wall
      dx, dy, room, mask = MapGenerator.select_random_room(dir)
      xx = x - dx
      yy = y - dy

      if map.check_space(xx-1, yy-1, mask, Tile.new(:Wall))
        if rand(2) == 1
          map[x,y]=:Floor
        else
          map[x,y]=:ClosedDoor
        end
        map.add_room(xx, yy, room)
      end
      
    end
    
    return map
  end

  ##
  # Creates a random direction and returns it
  #
  def MapGenerator.random_dir
    case rand(4)
      when 0 then return :up
      when 1 then return :left
      when 2 then return :down
      when 3 then return :right
    end
  end

  ##
  # Selects a random type of room, creates it, and returns it
  # Returns also its 'mask' (room+walls)
  # it also returns (dx,dy), coordinates of the room door in
  # the room's referential.
  #
  def MapGenerator.select_random_room(dir)
    h, w = [2+rand(6), 2+rand(6)]
    r = Matriz.new(w, h, Tile.new(:Floor))
    m = Matriz.new(w+2, h+2, Tile.new(:Floor))

    case dir
      when :up then dy=h; dx=rand(w)
      when :left then dx=w; dy=rand(h)
      when :down then dy=0; dx=rand(w)
      when :right then dx=0; dy=rand(h)
    end
    return [dx, dy, r, m]
  end

  ##
  # Cave generator, using neighbouring cells alogorithm
  #
  def MapGenerator.create_cave(w, h, seed=nil, max_floors=nil)
    map = Map.new(w,h, Tile.new(:Wall))
    srand(seed) if seed
    
    if !max_floors
      max_floors = w*h/2
    end

    # Select a starting point
    x = 1+rand(w-2)
    y = 1+rand(h-2)
    map.set_start(x, y)

    conv_list = Array.new

    max_floors.times do
      map[x,y]=:Floor

      [[x, y-1],
       [x, y+1],
       [x-1, y],
       [x+1, y]].each do |x1, y1|
        if( x1>0 && x1<w-1 && y1>0 && y1<h-1 && map[x1,y1].type==:Wall )
          if( rand(h/2)>conv_list.length )
            conv_list << [x1, y1]
          end
        end
      end

      r = rand(conv_list.length)
      x,y = conv_list[r] if conv_list[r]
      conv_list.delete([x,y])
    end

    return map
  end

  ##
  # Fields generator, simply scattering random trees
  # Later on, it will be able to add paths
  # 
  def MapGenerator.create_field(w, h, seed=nil, nb_trees=100, river=false)
    srand(seed) if seed

    map = Map.new(w, h, Tile.new(:Grass))

    # Let's create an altitude chart
    # FIXME
    alts = Matriz.new(w, h, rand)
    alt = rand
    alts.w.times do |i|
      alts.h.times do |j|
        alt =  alts[i-1, j] if alts [i-1, j]
        if map[i, j-1]
          alt += alts[i, j-1]
          alt /= 2 if alts [i-1, j]
        end
        alt -= rand / 5- 0.10
        alt = 1 - (rand / 10) if alt > 1
        alt = rand / 10 if alt < 0
        alts[i,j] = alt
        map[i,j] = :Hill if alt>0.7
      end
    end
    
    # Put on some random trees
    nb_trees.times do
      x, y = rand(w), rand(h)
      map[x,y] = :Tree
    end
    
    # Now, if we have a river, let's add it
    if river
      # Select a starting point
      x, y = rand(w), rand(h)
      finished = false
      while !finished do
        map[x,y] = :Water
        x2, y2 = MapGenerator.min_height(x, y, alts)
        if alts[x,y] > alts[x2,y2]
          x = x2
          y = y2
        else
          alts[x,y] +=0.5
          if alts[x-1,y]
            map[x-1, y] = :Water 
            alts[x-1,y] += 0.3
          end
          if alts[x,y-1]
            map[x, y-1] = :Water
            alts[x,y-1] += 0.3
          end
          if alts[x+1,y]
            map[x+1, y] = :Water
            alts[x+1,y] += 0.3
          end
          if alts[x,y+1]
            map[x, y+1] = :Water
            alts[x,y+1] += 0.3
          end
          x = x2
          y = y2
        end
        if x == 0 || x == w || y == 0 || y == h
          finished = true
        end
      end
    end

    return map
  end

  def MapGenerator.min_height(x, y, alts)
    pos = Array.new
    pos << [x-1, y, alts[x-1,y]] if alts[x-1,y]
    pos << [x, y-1, alts[x,y-1]] if alts[x,y-1]
    pos << [x+1, y, alts[x+1,y]] if alts[x+1,y]
    pos << [x, y+1, alts[x,y+1]] if alts[x,y+1]
    sel=pos.min { |a, b| a[2]<=>b[2] }
    return sel[0], sel[1]
  end

  ##
  # Set all the borders to 'map switcher'
  # May also add some 'special places' (caves and such)
  #
  def MapGenerator.add_map_switchers!(map)
    map.width.times do |i|
      map[i, 0].action = :go_up
      map[i, map.height-1].action = :go_down
    end
  
    map.height.times do |j|
      map[0, j].action = :go_left
      map[map.width-1, j].action = :go_right
    end
    rand(3).times do
      map[rand(map.width), rand(map.height)].action = :go_in
    end

    return map 
  end

end
