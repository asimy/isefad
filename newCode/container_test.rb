require 'test/unit'
require 'container'
class TC_Container < Test::Unit::TestCase

  def test_add
    container = Container.new(2,2,2)
    assert_equal(container.weight, 2)
  end

  def test_include
    container = Container.new(2,4,4)
    item = Container.new(1,1,1)
    container.add(item)
    assert(container.include?(item))
  end

  def test_full
    container = Container.new(3,1,1)
    item = Container.new(4,4,4)
    assert_raise(RuntimeError) do ||
      container.add(item)
    end
  end

  def test_remove
    container = Container.new(2,2,2)
    item = Container.new(1,1,1)

    container.add(item)
    assert(container.include?(item))

    container.remove(item)
    assert(!container.include?(item))
    
    assert_raise(RuntimeError) do ||
      container.remove(item)
    end
  end

  def test_weight
    container = Container.new(2,3,4)
    item = Container.new(2,1,1)

    container.add(item)
    assert_equal(container.weight, 4)
  end
end
