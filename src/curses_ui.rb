require 'game'
require 'curses'
require 'action'
require 'game_actions'

include Curses

=begin
  * Name: CursesUI
  * Description
      A game interface using curses
  * Author: elKano
  * Date: 13-02-06
  * License: GPL-2
=end

class CursesUI

  @@tileset = {
    :Floor      => {:char => ".", :color => COLOR_WHITE},
    :Trap       => {:char => "t", :color => COLOR_RED},
    :Wall       => {:char => "#", :color => COLOR_WHITE},
    :ClosedDoor => {:char => "+", :color => COLOR_RED},
    :Stair_up   => {:char => ">", :color => COLOR_WHITE},
    :Stair_down => {:char => "<", :color => COLOR_WHITE},
    :Column     => {:char => "0", :color => COLOR_WHITE},
    :Grass      => {:char => ".", :color => COLOR_GREEN},
    :Hill       => {:char => ":", :color => COLOR_GREEN},
    :Tree       => {:char => "T", :color => COLOR_RED},
    :Water      => {:char => "~", :color => COLOR_BLUE},
    :Mountain   => {:char => "^", :color => COLOR_WHITE},
    :Cave       => {:char => "*", :color => COLOR_WHITE}
  }

  @@pixset = {
    :tiger => 't',
    :frog  => 'f',
    :human => '@',
  }

  def initialize(debug=false)

    # Need to log?
    if debug
      require "logger"
      $log = Logger.new('logs/debug', 'daily')
    end

    @scr = Curses.init_screen
    Curses.start_color
    Curses.raw
    Curses.noecho
    Curses.curs_set(0)
    @scr.keypad(true)
    @scr.refresh
    
    # Color pairs definitions
    Curses.init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK);
    Curses.init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK);
    Curses.init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK);
    Curses.init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK);
    Curses.init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_BLACK);
    Curses.init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK);
    Curses.init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK);
    Curses.init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK);

    
    # Init the action map
    init_actions
    
    # Init game
    @game = Game.new

    # Draws the windows
    draw_windows
   
    game_loop
  end

  ##
  # Draws the game windows
  #
  def draw_windows
    # Map window
    @map_win = Window.new(20, 60, 0, 20)
    @map_win.refresh

    # Attributes window
    border_win = Window.new(20, 20, 0, 0)
    border_win.box(0,0)
    border_win << 'Attrs'
    border_win.refresh
    @att_win = Window.new(18, 18, 1, 1)
    @att_win.refresh

    # Messages window
    border_win = Window.new(10, 80, 20, 0)
    border_win.box(0,0)
    border_win << "Messages"
    border_win.refresh
    @mess_win = Window.new(8, 78, 21, 1)
    @mess_win.scrollok(true)
    @mess_win.refresh
  end
  
  ##
  # Draws the current view of the map onto the map window
  #
  def draw_map(win, x, y)
    map = @game.map
    a = x - win.maxx/2
    b = y - win.maxy/2
    (0..59).each do |i|
      (0..19).each do |j|
        win.setpos(j,i)
        if @game.player.memory[a+i,b+j]
          draw_tile(win, map[a+i,b+j])
        else
          draw_tile(win, nil)
        end
      end
    end
  end
  
  ##
  # Draws a tile to the given window
  #
  def draw_tile(win, tile)
    if tile
      style = tile.type
      win.attron(A_BOLD) 
      win.color_set(@@tileset[style][:color])
      win.addstr(@@tileset[style][:char])
    else
      win.addstr(" ")
    end
  end

  ##
  # Draws the player
  #
  def draw_player(win, i, j)
    win.setpos(j, i)
    win.attron(A_BOLD) 
    win.color_set(COLOR_YELLOW)
    win.addstr("@")
  end
  
  ##
  # Draws a creature
  #
  def draw_creature(win, a, b, creature)
    # Changing referential
    i = creature.x - a
    j = creature.y - b
    
    if i>0 && i<win.maxx && j>0 && j<win.maxy then
      win.setpos(j,i)
      win.attron(A_BOLD)
      case creature.age.to_f/creature.max_age.to_f
        when 0..0.25 then win.color_set(COLOR_YELLOW)
        when 0.25..0.5 then win.color_set(COLOR_CYAN)
        when 0.5..0.75 then win.color_set(COLOR_MAGENTA)
        when 0.75..1 then win.color_set(COLOR_RED)
      end
      win.addstr(@@pixset[creature.pix])
    end
  end
  
  ##
  # Draws all creatures
  #
  def draw_creatures(win, x, y)
    # Referential coordinates:
    a = x - win.maxx/2
    b = y - win.maxy/2

    @game.creatures.each do |c|
      if @game.player.memory[c.x, c.y]
        draw_creature(win, a, b, c)
      end
    end
  end

  ##
  # Regroup all drawing methods
  #
  def draw_all(win, x, y)
    draw_map(win, x,y)
    draw_player(win, win.maxx/2, win.maxy/2)
    draw_creatures(win, x, y) if @game.view == :current_map
    win.refresh
  end

  ##
  # Shows the text in the message window
  #
  def draw_message(win, m)
    win << m + "\n"
    win.scroll if win.cury == win.maxy
  end
 
  ##
  # Does the game loop (including key reading and dispatching)
  #
  def game_loop
    # Loop controller
    playing = true
    
    # Draw the screen first time
    x = @game.player.x
    y = @game.player.y
    draw_all(@map_win, x, y)
    
    # Real game loop
    while playing do
      # First, we show all queued messages
      while m = @game.read_message do
        draw_message(@mess_win, m)
      end
      @mess_win.refresh

      playing = handle_input(@scr)
    
      # Launches the game logics
      @game.iterate

      x = @game.player.x
      y = @game.player.y
      draw_all(@map_win, x, y)
    end
  end

 
  ##
  # Initialize a map of key / actions
  # For each key, the first actions whose test matches will be called.
  def init_actions

    # These are the keys whose only purpose is
    # to terminate the game.
    @@show_stoppers = [KEY_F2, 'q'[0]]
    
    # I don't know for you, but I don't like the idea that
    # I have to use this [0] all the time.
    # So I JUST GET RID OF IT.
    # D.R.Y.
    # btw, if I realize that most of the actions associated
    # to keys always have this no-parameter constructor, 
    # It might be better to use a map of key / class name, 
    # and have the class be built for ourselves.
    # End of the long comment.
    keys = { 'c' => [UndirectedChatAction.new],
      '<' => [GoInAction.new],
      '>' => [GoOutAction.new]}

    keys.each do |key, action|
      @@actions[key[0]] = action
    end
    
    # Special handling for arrow keys
    dirs = {KEY_UP => :up, 
      KEY_LEFT => :left, 
      KEY_RIGHT => :right, 
      KEY_DOWN => :down}
      
    dirs.each do |key, dir|
      # Specify it here if arrow 
      # keys need to be given another meaning
      @@actions[key] = [ChatAction.new(dir), 
                        MoveAction.new(dir)]
    end
      
    
  end  
    
  # Work out the input
  def handle_input(scr)
    keep_playing = true
    
    key = scr.getch
    
    if (@@show_stoppers.include?(key))
      keep_playing = false
    else
      if (@@actions.has_key?(key))
        attempts = @@actions[key]
        # This will go through all the actions 
        # until one is executed (if any)
        attempts.find do |action| 
          action.attempt(@game) 
        end
      end
    end
        
    return keep_playing
  end

end
