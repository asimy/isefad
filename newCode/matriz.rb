=begin
  * Name: Matriz
  * Description
      This class allows easy working with a map matrix
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Matriz
  attr :w
  attr :h
  def initialize(width, height, filler)
    @h = height
    @w = width
    @bg= filler
    @m = []
    @h.times do
      a=Array.new
      @w.times { a << filler.dup }
      @m << a
    end  
  end
  
  ##
  # Gets the value in column x, line y
  #
  def [](x,y)
    if x>-1 && x<@w && y>-1 && y<@h
      return @m[y][x]
    else
      return nil
    end
  end

  ##
  # Gets the value in column x, line y
  #
  def []=(x,y,value)
    if x>-1 && x<@w && y>-1 && y<@h
      @m[y][x]=value
    end
  end

  ##
  # similar to []=, but adds all the values in Matriz vals
  # but Map::Trans, which is considered 'transparency'
  #
  def ins_values(x,y,vals)
    for j in 0..vals.h-1 do
      for i in 0..vals.w-1 do
        if x+i>0 && x+i<@w && y+j>0 && y+j<@h && vals[i,j]!=Map::Trans
          self[i+x,j+y]=vals[i,j]
        end
      end
    end
  end

  ##
  # similar to [], but returns a new Matrix representing all
  # values from x,y to x+w,y+h
  #
  def get_values(x,y,w,h)
    ret = Matriz.new(w,h,'#')
    for j in 0..h-1 do
      for i in 0..w-1 do
        if x+i>0 && x+i<@w && y+j>0 && y+j<@h
          ret[i,j]=self[x+i,y+j]
        end
      end
    end
    return ret
  end

  ##
  # Returns true if the rectangle x,y,w,h is filled with @bg
  #
  def empty?(x,y,w,h)
    ret = true
    for i in x..x+w do
      for j in y..y+h do
        if i>0 && j>0 && i<@w-1 && j<@h-1
          ret= ret && (self[i,j]==@bg)
        else
          ret=false
        end
      end
    end
    return ret
  end

  ##
  # Returns a string representing the Matrix contents, line by line
  #
  def to_s
    s=""
    @m.each do |l|
      l.each do |c|
        s = s+c.to_s
      end
      s = s+"\n"
    end
    return s
  end
end
