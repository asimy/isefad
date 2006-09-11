require 'game'
require 'action'

=begin
  * Name: MoveAction
  * Description:
      Action to move the player around
  * Author: phtrivier
  * Date: 11-09-06
  * Licence: GPL-2
=end

## Comodity
# Should be replaced by a test whether the coast is clear
Truth = lambda {|game| return true}

class MoveAction < Action
  ##
  # Initialize an action to go into a certain direction
  def initialize(dir)
    super(Truth, lambda{|game| game.player.move_dir(dir)})
  end
end

class GoInAction < Action
  ##
  # Set up an action to go into a cavern
  def initialize
    super(Truth, lambda{|game| game.player.go_in})
  end
end

class GoOutAction < Action
  ##
  # Set up an action to go into a cavern
  def initialize
    super(Truth, lambda{|game| game.player.go_out})
  end
end

class ChatAction < Action

  # Here we, might want to get things OUT
  # of the game and put the actual code ... here
  def initialize(dir)
    super(lambda{|game| game.friendly?(dir)}, 
          lambda{|game| game.chat(dir)})
  end

end

class UndirectedChatAction < Action
  def initialize
    super( lambda{|game| 
             # Keep the direction, so that we know where to chat later
             @dir = game.any_friendly? 
             return (@dir != nil)
           } ,
           lambda{|game|
             # Here we can assume that there is a dir
             if (@dir == nil) 
               raise "No direction was computed" 
             end
             game.chat(@dir)
           } )
  end
end
           
   
