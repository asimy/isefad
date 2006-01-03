# This class loads the different monster types from a file
# and stores them in a hashtable for easy use

class MonsterList
   def initialize(listFile, log)
      @log=log
      dataFile=File.open("infos/"+listFile, "r")
      if dataFile!=nil
         @data=readValues(dataFile)
      else
         log.error "File: "+listFile+" not found."
      end
      dataFile.close
   end

   def data
      return @data
   end
   
   def readValues(file)
      data=Hash.new
      
      line=file.gets
      while line!=nil do
         # Match Type definition?
         re=/\s*TYPE\s*<(.*)>/
         m=re.match(line)
         if(m!=nil) then
            monster=MonsterType.new(m[1])
         end

         # Match description?
         re=/\s*DESC:\s*(.*)/
         m=re.match(line)
         if(m!=nil) then
            monster.desc << m[1]
         end

         # Match health
         re=/\s*HP:\s*(\d+)/
         m=re.match(line)
         if(m!=nil) then
            monster.hp=m[1].to_i
         end

         # Match Experience
         re=/\s*XP:\s*(\d+)/
         m=re.match(line)
         if(m!=nil) then
            monster.xp=m[1].to_i
         end

         # Match Strength
         re=/\s*ST:\s*(\d+)/
         m=re.match(line)
         if(m!=nil) then
            monster.st=m[1].to_i
         end

         # Match Agility
         re=/\s*AG:\s*(\d+)/
         m=re.match(line)
         if(m!=nil) then
            monster.ag=m[1].to_i
         end
         
         # Match IA
         re=/\s*IA:\s*(.+)/
         m=re.match(line)
         if(m!=nil) then
            monster.ia=m[1]
         end
         
         # Match IA
         re=/\s*CH:\s*(.+)/
         m=re.match(line)
         if(m!=nil) then
            monster.char=m[1]
         end
         
         # End of Type definition
         re=/\s*ENDTYPE\s*/
         if re.match(line)!=nil
            data[monster.name]=monster
            @log.info monster
         end
         
         
         line=file.gets
      end

      return data
   end
end

# This class describes one element of the MonsterList
class MonsterType
   attr_accessor :name, :desc, :xp, :hp, :st, :ag, :ia, :char, :attacks
   
   def initialize(name)
      @name=name
      @desc=""
   end

   def addAttack(name, speed, strength)
   end
end
