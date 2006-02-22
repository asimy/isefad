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
    @att_win = Window.new(20, 20, 0, 0)
    @att_win.box(0,0)
    @att_win << 'Attrs'
    @att_win.refresh

    # Messages window
    @mess_win = Window.new(10, 80, 20, 0)
    @mess_win.box(0,0)
    @mess_win << 'Messages'
    @mess_win.refresh
  end
  
  ##
  # Draws the current view of the map onto the map window
  #
  def draw_map(x, y)
    map = @game.map
    (0..59).each do |i|
      (0..19).each do |j|
        @map_win.setpos(j,i)
        draw_tile(@map_win, map[x-30+i,y-10+j])
      end
    end
    @map_win.refresh
  end
  
  ##
  # Draws a tile to the given window
  #
  def draw_tile(win, tile)
    if tile
      if tile.app_type
        style = tile.app_type
      else
        style = tile.type
      end
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
    win.refresh
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
    draw_map(x,y)
    draw_player(@map_win, 30, 10)
    
    # Real game loop
    while playing do
      case @scr.getch
        when KEY_UP then @game.player.move_dir(:up)
        when KEY_LEFT then @game.player.move_dir(:left)
        when KEY_DOWN then @game.player.move_dir(:down)
        when KEY_RIGHT then @game.player.move_dir(:right)
        when KEY_F2, 'q'[0] then playing = false
      end
      x = @game.player.x
      y = @game.player.y
      draw_map(x, y)

      draw_player(@map_win, 30, 10)
    end
  end
end