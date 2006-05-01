=begin
  * Name: CreatureRepartition
  * Description
      It contains a simple description of the creature population
      of an area, and the methods for its manipulation.
  * Author: elKano
  * Date: 04-03-06
  * License: GPL-2
=end

class CreatureRepartition

  ##
  # Given a creatures array and a date. it returns its repartition
  #
  def CreatureRepartition.create(date, creats)
    ret = Hash.new
    ret[:date] = date
    creats.each do |c|
      if ret[c.name] 
        if c.gender == :M
          ret[c.name][0] += 1
        else
          ret[c.name][1] += 1
        end
      else 
        if c.gender == :M
          ret[c.name][0] = 1
        else
          ret[c.name][1] = 1
        end
      end
    end

    return CreatureRepartition.new(ret)
  end

  ##
  # FIXME
  # Returns a random repartition given an array of creature types,
  # a number of creatures to create, and a date.
  #
  def CreatureRepartition.create_random(date, creats, nb)
    ret = Hash.new
    ret[:date] = date
    
    #FIXME how many of each kind
    m = nb/creats.length 
    creats.each do |c|
      ret[c] = [(m+1)/2, m/2]
    end
    
    return CreatureRepartition.new(ret)
  end

  def initialize(r)
    @repartition = r
  end
  
  ##
  # FIXME not an easy one, it's some artificial life simulator
  # Evolves the repartition to time t
  #
  def evolve!(t)
  end

  ##
  # Populates given map with the current repartition,
  # and returns an array with the created creatures.
  #
  def populate(game, map)
    ret = Array.new
    
    @repartition.each do |name, rep|
      if name != :date
        rep[0].times do
          begin
            x, y = [rand(map.width), rand(map.height)]
          end while(not game.empty?(x,y,map)) 
        
          creat = CreatureGenerator.create(game, name, x, y, :M)
          ret << creat
        end
  
        rep[1].times do
          begin
            x, y = [rand(map.width), rand(map.height)]
          end while(not game.empty?(x,y,map)) 
        
          creat = CreatureGenerator.create(game, name, x, y, :F)
          ret << creat
        end
      end
    end
    
    return ret
  end
end
