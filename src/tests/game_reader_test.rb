=begin
  * Name: GameReaderTest
  * Description:
     Test for the automated game reader
  * Author: phtrivier
  * Date: 25-10-06
  * Licence: GPL-2
=end

require 'test/unit'
require 'test_utils'
require 'game_reader'

class GameReaderTest < Test::Unit::TestCase
  
  
  def setup
    @desc = [".T.", ".@.", "..."]
    @reader = GameReader.new
  end

  def teardown
  end

  def test_break_parse_contract
    assert_not_nil(@reader)
    assert_false(@reader.game_read?)
    assert_raise(RuntimeError) {@game = @reader.game}
  end
  
  def test_parse_simple_desc
    assert_not_nil(@reader)
    assert_false(@reader.game_read?, "no game should be read at startup")
    @reader.map_description= @desc
    @reader.read_game
    assert_true(@reader.game_read?, "game should be read now")
    assert_not_nil(@reader.game, "generated game should not be null")    
    assert_not_nil(@reader.game.map, "map should be created")
    assert_equal(3, @reader.game.map.height, "size is incorrect")
    assert_equal(3, @reader.game.map.width, "size is incorrect")
    assert_equal(:Grass, @reader.game.map[0,0].type, "First tile should be grass")
    assert_not_nil(@reader.game.player)
    player = @reader.game.player
    assert_equal(1, player.x)
    assert_equal(1, player.y)
    assert_equal(1, player.speed)
    assert_equal(:Tree, @reader.game.map[1,0].type, "Second tile should be a tree")
  end
  
 
end
