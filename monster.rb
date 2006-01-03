require 'character'
# Generic Monster Class.
# It takes all the data from a file

class Monster < Character

   attr :isSeen, true # The player sees him?
   def initialize(x,y,map,type,typelist, log)
      super(x,y,map,log)

      @type=typelist[type]
      @hp  =@type.hp
      @char=@type.char
   end

   def hurt(p)
      @hp=@hp-p
   end

   # Get the attributes
   def name
      return @type.name
   end

   def desc
      return @type.desc
   end

   def ag
      return @type.ag
   end

   def st
      return @type.st
   end
   
   def hp
      return @hp
   end
end
