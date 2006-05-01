=begin
  * Name: Yieldable
  * Description
       Anything that can be yielded. Includes weapons and shields
       (and anything that can be used for that), as well as torchs.
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class Yieldable < Container
  def yield
    @yielded = true
  end
  def unyield
    @yielded = false
  end
  def yielded?
    return @yielded
  end
end
