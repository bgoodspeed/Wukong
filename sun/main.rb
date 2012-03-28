# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"
#s = Screen.new(640, 480)
#s.show

game = Game.new({:width => 640, :height => 480})
game.movement_distance = 1
game.turn_speed = 10
path_manager = PathFollowingManager.new(game)
game.path_following_manager = path_manager

game.load_level("test-data/levels/trivial/trivial.yml")
wf = WayFinding.from_file("test-data/levels/trivial/wayfinding.yml")
game.wayfinding = wf


p = Player.new("test-data/sprites/avatar.bmp", game)
w = Weapon.new(game, "test-data/equipment/weapon.png")
w.type = "projectile"
p.equip_weapon(w)
p.position = [300,200]
game.set_player(p)
e = Enemy.new("test-data/sprites/enemy_avatar.bmp", game)
e.position = [100,100]
game.set_enemy(e)
e.tracking_target = p
path_manager.add_tracking(e, wf)


game.show

