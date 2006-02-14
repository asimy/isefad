require 'curses'
include Curses
# This class provides with a 'client', that is, a user interface showing the current game
# and taking input from the user

class CursesClient
   def initialize(w,h, player, log)
      @scr=Curses.init_screen
      Curses.start_color
      @win=Window.new(h,w,0,0)
      Curses.raw
      Curses.noecho
      Curses.curs_set(0)
      @scr.keypad(true)
      @scr.refresh
      @log = log

      # Color pairs definitions
      Curses.init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK);
      Curses.init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK);
      Curses.init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK);
      Curses.init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK);
      Curses.init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_BLACK);
      Curses.init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK);
      Curses.init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK);
      Curses.init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK);
   end

   def close
   end

   def update(player, monsters, map)
      x,y=player.fovpos
      x_mem=x
      fov_x=x
      fov_y=y
      
      player.fov.to_s.each_line do |l|
         l= l.chop
         l.each_byte do |c|
            @win.setpos(y,x)
            case c
               when Map::Trans[0] then c=-1
               when Map::ClosedDoor[0],Map::OpenDoor[0] then @win.color_set(COLOR_RED)
               else @win.color_set(COLOR_WHITE)
            end
            if c>-1 then @win.addch c end
            x=x+1
         end
         y=y+1
         x=x_mem
      end
 
      monsters.each do |monster|
         mx,my,char=monster.pos
         # Only write it to screen if the player can see it
         # This is not working well... actually it is working bad, I have to review it.
         if player.sees?(my,mx)
            @win.setpos(mx,my)
            @win.color_set(COLOR_GREEN)
            @win.addstr char
         end
         if player.isBy?(my,mx)
            @log.info "You are standing by #{monster.name}"
         end
      end
      
      x,y,char=player.pos
      @win.setpos(y,x)
      @win.attron(A_BOLD)
      @win.color_set(COLOR_YELLOW)
      @win.addstr char
      @win.attroff(A_BOLD)

      @win.refresh
   end
   
   def readkey
      k=@scr.getch
      case k
         when KEY_UP then key="8"
	      when KEY_LEFT then key="4"
         when KEY_DOWN then key="5"
	      when KEY_RIGHT then key="6"
	      when KEY_F2 then key="q"
	      else key=k.chr
      end
      return key
   end
end
