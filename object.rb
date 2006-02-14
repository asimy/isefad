# The big father class.
# It describes the container system.
# Every item, creature, etc. class, takeable or able to contain anything,
# shall inherit from this one.
# The capacity is measured in a simple unit, let's call it 'unit'
# which hybridly can describe wheight or volume.
class Object
   def initialize(capacity=100, unit=1)
      @contains = Array.new
      @capacity = capacity
      @unit=unit
      @volume=0
   end

   def add(obj)
      if obj.unit+@volume < @capacity then
         @contains << obj
         @volume = @volume + obj.unit
      end
   end
end
