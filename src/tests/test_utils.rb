require 'test/unit'

module Test::Unit::Assertions
  def assert_false(tested, message=nil)
    assert((not tested), message)
  end
  
  def assert_true(tested, message=nil)
    assert(tested, message)
  end
  
end
