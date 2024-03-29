=begin
  * Name: Container
  * Description
      Any object that can contain one or more others. All classes should
      inherit from this one.
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Container
  def initialize(weight, max_weight, max_items)
    @contained = Array.new
    @intrinsec_weight = weight
    @max_weight = max_weight + weight
    @max_items = max_items
    @weight = @intrinsec_weight
  end

  protected
  ##
  # Adds the item to the container.
  # It raises an exception if the item is not containable or if the
  # container is full
  #
  def add(item)
    if item.respond_to? :weight
      if (@weight+item.weight < @max_weight) && @contained.length+1<@max_items
        @contained << item
        @weight += item.weight
      else
        raise "Container full."
      end
    else
      raise "Bad item, incompatible with Container"
    end
  end

  ##
  # Removes an item from the container.
  # It raises an exception if the item is not in the container
  #
  def remove(item)
    if @contained.include? item
      @contained.delete item
      @weight -= item.weight
    else
      raise "Item not in container"
    end
  end

  public
  ##
  # Returns true if the item is in the container, false otherwise
  #
  def include? item
    return @contained.include?(item)
  end

  ##
  # Removes an item from itself and adds it to another container
  #
  def give(item, dest)
    if dest.respond_to? :add then
      begin
        dest-add(item)
        self.remove(item)
        if $log
          $log.debug "A "+item+" has changed hands."
        end
      rescue RuntimeError
        if $log
          $log.warn dest+" has reached it's storage limits."
        end
      end
    end
  end

  ##
  # Removes all items from itself and adds them to another container
  #
  def give_all(dest)
    @contained.each do |item|
      self.give(item, dest)
    end
  end


  ##
  # Returns the current global weight (intrinsec+containeds)
  #
  def weight
    return @weight
  end

  ##
  # Return the number of items currently contained
  #
  def nb_items
    return @contained.length
  end

  ##
  # Return the intrinsec weight of the item (empty weight)
  #
  def intrinsec_weight
    return @intrinsec_weight
  end
end
