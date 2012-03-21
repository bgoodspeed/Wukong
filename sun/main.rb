# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"
#s = Screen.new(640, 480)
#s.show

game = Game.new({:width => 640, :height => 480})
game.movement_distance = 1
game.turn_speed = 10

game.load_level("test-data/levels/huge/huge.yml")
p = Player.new("test-data/sprites/avatar.bmp", game)
w = Weapon.new(game, "test-data/equipment/weapon.png")
w.type = "projectile"
p.equip_weapon(w)
p.position = [300,200]
game.set_player(p)
e = Enemy.new("test-data/sprites/enemy_avatar.bmp", game)
e.position = [100,100]
game.set_enemy(e)
game.show

