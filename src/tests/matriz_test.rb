=begin
  * Name: MatrizTest
  * Description:
     Test for the Matriz class
  * Author: phtrivier
  * Date: 25-10-06
  * Licence: GPL-2
=end

require 'matriz'

class MatrizTest < Test::Unit::TestCase
  def setup
    @m = Matriz.new(3,2, {})
    k = 1
    (0..1).each do |y|
      (0..2).each do |x|
       
        @m[x,y] = k
        #puts("#{x},#{y},#{k}, #{@m[x,y]}")
        k = k + 1
    
      end
    end
  end

  def test_position
    assert_equal(3, @m[2,0])
    assert_equal(5, @m[1,1])
  end

  def test_traversal
    assert_not_nil(@m.find {|v| v == 6})    
    assert_nil(@m.find{|v| v == 7})
  end

end
  
