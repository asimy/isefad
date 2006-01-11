#!/usr/bin/ruby
# This class is mainly used to test other objects

require "map.rb"
#require "matriz"
require "player"
require "client"
require "logger"
require "monsterList"
require "monster"

w=80
h=25
log=Logger.new("logs/isefad_error_"+Time.now.strftime("%Y%m%d_%H%M")+".log")
log.info "Beginning:"
mapa = Map.new(w, h,log)
stx,sty = mapa.create(60)
log.info "  Map created"
player = Player.new(stx,sty, mapa,log)
log.info "  Player created"
client = CursesClient.new(w,h, player, log)
log.info "  Client created"
monsterList = MonsterList.new("monsters.info", log)

monsters = Array.new
x,y=mapa.find_empty
monsters << Monster.new(y,x, mapa,'Goblin',monsterList.data, log)

client.update(player, monsters, mapa)
k=client.readkey
while(k!='q') do
   case k
      when "8" then player.move(0, mapa)
      when "6" then player.move(1, mapa)
      when "5" then player.move(2, mapa)
      when "4" then player.move(3, mapa)
   end
   client.update( player, monsters, mapa)
   k=client.readkey
end

client.close
log.info "Bye!"
