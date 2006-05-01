=begin
  * Name: Food (Mixin)
  * Description
      Any food has to implement this module
  * Author: elKano
  * Date: 1-05-06
  * License: GPL-2
=end

module Food
  attr_reader :kind, :size

  def define_food (kind, size)
    @kind = kind
    @size = size
  end

  def meat?
    return @kind == :meat
  end
  
  def veggie?
    return @kind == :veggie
  end

  def be_eaten
    @size -= 1 if @size > 0
    
    @kind = :exhausted if @size == 0
  end
end
