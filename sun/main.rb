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

game.load_level("test-data/levels/large/large.yml")
wf = WayFinding.from_file("test-data/levels/trivial/wayfinding.yml")
game.wayfinding = wf


game.movement_distance = 2
game.turn_speed = 5

p = Player.new("test-data/sprites/avatar.bmp", game)
w = Weapon.new(game, "test-data/equipment/weapon.png")
w.sound_effect_name = "shoot"

sm = SoundManager.new(game)
game.sound_manager = sm
sm.add_effect("test-data/sounds/weapon.wav", "shoot")
sm.add_song("test-data/music/music.wav", "music")
w.type = "projectile"
p.equip_weapon(w)
p.position = [300,200]
game.set_player(p)
e = Enemy.new("test-data/sprites/enemy_avatar.bmp", game)
e.position = [100,100]
e.velocity = 1
game.set_enemy(e)
e.tracking_target = p
path_manager.add_tracking(e, wf)


hud = HeadsUpDisplay.new(game)
game.hud = hud
hud.add_line("here is hud line one")

sm.play_song("music", true)
game.show

