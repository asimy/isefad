require 'game'
require 'curses'
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
  }

  @@pixset = {
    :tiger => 't',
    :frog  => 'f'
  }

  def initialize
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
        draw_tile(win, map[a+i,b+j])
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
      draw_creature(win, a, b, c)
    end
  end

  ##
  # Regroup all drawing methods
  #
  def draw_all(win, x, y)
    draw_map(win, x,y)
    draw_player(win, win.maxx/2, win.maxy/2)
    draw_creatures(win, x, y)
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
      
      # Work out the input
      case @scr.getch
        when KEY_UP then @game.player.move_dir(:up)
        when KEY_LEFT then @game.player.move_dir(:left)
        when KEY_DOWN then @game.player.move_dir(:down)
        when KEY_RIGHT then @game.player.move_dir(:right)
        when KEY_F2, 'q'[0] then playing = false
      end

      # Launches the game logics
      @game.iterate

      x = @game.player.x
      y = @game.player.y
      draw_all(@map_win, x, y)
    end
  end
end
