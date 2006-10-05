#!/usr/bin/ruby

#
# == Synopsis
# launch.rb: It launches a game of Isefad, with Curses interface.
#
# == Usage
# ./launch.rb [OPTION]
# 
# -h, --help: 
#     Shows this help
# -d, --debug [level]
#     Launches the game in debug mode, creating a 'debug' file in 'logs/'
#     If a level is not specified, level 1 is used.
#     Levels go from 0 to 4, where 0 means 'log everything'
#     and 4 'log just fatal errors'

$:<<'src'
require 'curses_ui'
require 'getoptlong'
require 'rdoc/ri/ri_paths'
require 'rdoc/usage'

opts = GetoptLong.new([ '--help', '-h', GetoptLong::NO_ARGUMENT ],
                      [ '--debug', '-d', GetoptLong::OPTIONAL_ARGUMENT ]
                     )

debug = false
opts.each do |opt, arg|
  case opt
  when '--help'
    RDoc::usage
  when '--debug'
    if arg == ''
      debug = 1
    else
      debug = arg.to_i
    end
 end
end

# Need to log?
if debug
  require "logger"
  $log = Logger.new('logs/debug', 'daily')

  case debug
  when 0 
    $log.level = Logger::DEBUG
  when 1
    $log.level = Logger::INFO
  when 2
    $log.level = Logger::WARN
  when 3
    $log.level = Logger::ERROR
  when 4
    $log.level = Logger::FATAL
  else RDoc::usage
  end
end



CursesUI.new()
