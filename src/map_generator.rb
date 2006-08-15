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
  def MapGenerator.create_field(w, h, seed=nil, nb_trees=50, river=false)
    srand(seed) if seed

    map = Map.new(w, h, Tile.new(:Grass))

    # Let's create an altitude chart
    alts = MapGenerator.create_altitude_chart(w, h)

    # Finally, let's send all these changes to the real map
    w.times do |x|
      h.times do |y|
        case alts[x, y]
        when 0..0.6 
          map[x,y] = :Grass
        when 0.6..2
          map[x,y] = :Hill
        else
          map[x,y] = :Mountain
        end
      end
    end
    
    # Put on some random trees
    nb_trees.times do
      x, y = rand(w), rand(h)
      map[x,y] = :Tree
    end
    
    # Now, if we have a river, let's add it
    if river
      MapGenerator.add_river!(map, alts)
    end

    return map
  end

  ##
  # To create a forest, we just create a field with a *lot* of trees
  def MapGenerator.create_forest(w, h, seed=nil, river=false)
    return MapGenerator.create_field(w, h, seed, w*h/5, river)
  end
  ##
  # This method creates a random altitude chart and returns it
  #
  def MapGenerator.create_altitude_chart(w, h, mountains=false)
    alts = Matriz.new(w,h, 0.5)

    # Let's surround the map with huge mountains is switch is on
    if mountains then
      w.times do |i|
        MapGenerator.change_height(i, 0, 0.6, alts)
        MapGenerator.change_height(i, h-1, 0.6, alts)
      end
      h.times do |j|
        MapGenerator.change_height(0, j, 0.6, alts)
        MapGenerator.change_height(w-1, j, 0.6, alts)
      end
    end

    # Now, let's modify randomly the map heights.. a couple of times ;)
    rand(w*h/10).times do 
      x = rand(w)
      y = rand(h)
      MapGenerator.change_height(x, y, rand-0.5, alts)
    end
    
    return alts
  end

  ##
  # This method adds a river to the map, using the altitude chart
  #
  def MapGenerator.add_river!(map, alts)
    x, y = rand(map.width), rand(map.height)
    finished = false
    while !finished do
      map[x,y] = :Water
      x2, y2 = MapGenerator.min_height(x, y, alts)
      if alts[x,y] > alts[x2,y2]
        x = x2
        y = y2
      else
        alts[x,y] += 1
        if alts[x-1,y]
          map[x-1, y] = :Water 
          alts[x-1,y] += 0.9
        end
        if alts[x,y-1]
          map[x, y-1] = :Water
          alts[x,y-1] += 0.9
        end
        if alts[x+1,y]
          map[x+1, y] = :Water
          alts[x+1,y] += 0.9
        end
        if alts[x,y+1]
          map[x, y+1] = :Water
          alts[x,y+1] += 0.9
        end
        x = x2
        y = y2
      end
      if x == 0 || x == map.width || y == 0 || y == map.height
        finished = true
      end
    end
  end

  ##
  # It creates the worldmap, that is, the huge map that includes all others
  # (muahahaha)
  #
  def MapGenerator.create_worldmap(w, h, seed=nil)
    srand(seed) if seed

    map = WorldMap.new(w, h)
    # We're gonna use an altitude chart to set up the environment
    alts = MapGenerator.create_altitude_chart(w, h, true)

    # Finally, let's send all these changes to the real map
    w.times do |x|
      h.times do |y|
        case alts[x, y]
        when 0..0.6 
          map[x,y] = :Grass
        when 0.6..1 
          map[x,y] = :Hill
        else
          if rand(20)==1
            map[x,y] = :Cave
          else 
            map[x,y] = :Mountain
          end
        end
      end
    end
    
    # Now, we add a river ('cause we have a river)
    MapGenerator.add_river!(map, alts)

    # Put on some random trees (forests)
    (w*h/100).times do
      x, y = rand(w), rand(h)
      map[x,y] = :Tree
    end
 
   
    return map
  end

  ##
  # It modifies the height at one point of the altitude chart, and all around it
  def MapGenerator.change_height(x, y, delta, alts)
    alts[x, y] += delta if alts[x, y]
    if delta > 0.1 then
      MapGenerator.change_height(x-1, y, delta/2, alts) if alts[x-1, y]
      MapGenerator.change_height(x+1, y, delta/2, alts) if alts[x+1, y]
      MapGenerator.change_height(x, y-1, delta/2, alts) if alts[x, y-1]
      MapGenerator.change_height(x, y+1, delta/2, alts) if alts[x, y+1]
    end
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
