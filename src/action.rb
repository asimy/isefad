require 'dbc'

=begin
  * Name: Action
  * Description:
     Base class for player's action
  * Author: phtrivier
  * Date: 11-09-06
  * Licence: GPL-2
=end

class Action

  include DesignByContract
  
  ##
  # initialize : creates an action from a test block
  # and an action block
  pre(:initialize, "not nil") {|test, action| test!=nil && action!=nil}
  def initialize(test, action)
    @test = test
    @action = action
  end

  
  ##
  # if the test block returns true when applied to a game,
  # applies the action block on the game.
  # Return true if the attempt was succesfull ; that is, 
  # the test returned true.
  def attempt (game)
    res = false
    if (@test.call(game))
      @action.call(game)
      res = true
    end
    return res
  end

end
