# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"
#s = Screen.new(640, 480)
#s.show

game = Game.new({:width => 640, :height => 480})
game.movement_distance = 1
game.turn_speed = 10

game.load_level("test-data/levels/trivial/trivial.yml")
p = Player.new("test-data/sprites/avatar.png", game)
p.position = [300,200]
game.set_player(p)

game.show

