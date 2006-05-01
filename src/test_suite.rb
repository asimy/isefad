require 'test/unit'
require 'test/unit/ui/tk/testrunner'

Dir['*test.rb'].each do|t|
  require t
end
#Test::Unit::UI::Tk::TestRunner.run(TC_Container)
