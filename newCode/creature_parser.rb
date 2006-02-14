require 'yaml'

=begin
  * Name: CreatureParser
  * Description
       Reads a YAML creature definition file, and creates some array with
       each kind of creature as a hash
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class CreatureParser
  def initialize( filename)
    @filename = filename
  end

  ##
  # Reads the nodes, and returns an array of hashes
  #
  def read
    file = File.open( @filename )
    ret = Array.new
    
    yp = YAML::parse_documents( file ) do |tree|
      ret << tree.transform
    end

    file.close

    return ret
  end
end
