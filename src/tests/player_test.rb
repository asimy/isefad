=begin
  * Name: PlayerTest
  * Description:
     Test for the player class
  * Author: phtrivier
  * Date: 12-11-06
  * Licence: GPL-2
=end
require 'test/unit'
require 'test_utils'

class PlayerTest < Test::Unit::TestCase
  def setup
    @desc = [".T.", ".@.", "..T"]
    @reader = GameReader.new
    @reader.map_description = @desc
    @reader.read_game
    assert_true(@reader.game_read?)
    @game = @reader.game
    assert_not_nil(@game.player)
    @player = @game.player
  end

  def test_move_up_down
    @player.move_dir(:down)
    assert_equal(2, @player.y)
    2.times do @player.move_dir(:up) end
    assert_equal(1, @player.y)    
  end

  def test_move_right_left
    @player.move_dir(:right)
    assert_equal(2, @player.x)
    @player.move_dir(:left)
    assert_equal(1, @player.x)
    @player.move_dir(:down)
    assert_equal(2, @player.y)
    @player.move_dir(:right)
    assert_equal(2, @player.y)
    assert_equal(1, @player.x)
  end
    
    
  def teardown
  end
end
