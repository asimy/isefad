#!/usr/bin/ruby
$:<<'src'
$:<<'src/tests'
require 'test/unit'

Dir['./src/tests/*test.rb'].each do|t|
  require t
end
