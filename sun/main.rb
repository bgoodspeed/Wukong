# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"
#s = Screen.new(640, 480)
#s.show

game = Game.new({:width => 640, :height => 480})
game.movement_distance = 2
game.turn_speed = 5
path_manager = PathFollowingManager.new(game)
game.path_following_manager = path_manager

#game.load_level("test-data/levels/large/large.yml")
game.load_level("test-data/levels/obstacle/obstacle.yml")
wf = WayFinding.from_file("test-data/levels/trivial/wayfinding.yml")
game.wayfinding = wf



p = Player.from_file(game, "game-data/players/player.yml")
w = Weapon.from_file(game, "game-data/equipment/weapon.yml")

sm = SoundManager.new(game)
game.sound_manager = sm
#TODO make a sound effects config yml
sm.add_effect("test-data/sounds/weapon.wav", "shoot")
sm.add_song("test-data/music/music.wav", "music")
p.equip_weapon(w)
game.set_player(p)
e = Enemy.from_file(game, "game-data/enemies/enemy.yml")
game.add_enemy(e)
e.tracking_target = p
path_manager.add_tracking(e, wf)


hud = HeadsUpDisplay.new(game)
game.hud = hud
hud.add_line("here is hud line one")

menu_manager = MenuManager.new(game)
game.menu_manager = menu_manager

menu = Menu.from_file("test-data/menus/main.yml")
menu_manager.add_menu(game.main_menu_name, menu)


sm.play_song("music", true)
game.show

