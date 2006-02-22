require 'yaml'
require 'creature'

=begin
  * Name: CreatureGenerator
  * Description
       Reads a YAML creature definition file, and creates some hash with
       each kind of creature as a hash; is able to create the actual
       Creature objects and return them 
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class CreatureGenerator

  #@@creature_types = Hash.new

  ##
  # Reads the nodes, and returns a hash of hashes
  #
  def CreatureGenerator.read(filename)
    file = File.open( filename )
    ret = Hash.new
    
    yp = YAML::parse_documents( file ) do |tree|
      t = tree.transform
      ret[t['NAME']] = t
    end

    file.close

    @@creature_types = ret

    return ret
  end

  ##
  # Return a given creature (called by type)
  #
  def CreatureGenerator.create(game, name, x, y, speed=1)
    data = @@creature_types[name]

    puts data
    atts = ''

    c = Creature.new(game, x, y, speed, data['AI'], atts)
    
  end

end
