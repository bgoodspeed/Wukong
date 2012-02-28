# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"
#s = Screen.new(640, 480)
#s.show

game = Game.new({:width => 640, :height => 480})
game.load_level("test-data/levels/trivial/trivial.yml")
game.player = Player.new("test-data/sprites/avatar.png", game.window)

game.show

