# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"

game = Game.new({:width => 640, :height => 480})
path_manager = PathFollowingManager.new(game)
game.path_following_manager = path_manager
cr = CollisionResponder.from_file(game, "test-data/collision_response/collision_response.yml")
game.collision_responder = cr
#game.load_level("test-data/levels/large/large.yml")
game.load_level("game-data/levels/obstacle/obstacle.yml")
im = InputManager.from_file(game, "test-data/input/input_config.yml")
game.input_manager = im
p = Player.from_file(game, "game-data/players/player.yml")
w = Weapon.from_file(game, "game-data/equipment/weapon.yml")

sm = SoundManager.from_file(game, "game-data/sounds/sound_config.yml")
game.sound_manager = sm
p.equip_weapon(w)
game.set_player(p)
e = Enemy.from_file(game, "game-data/enemies/enemy.yml")
game.add_enemy(e)
e.tracking_target = p
path_manager.add_tracking(e, game.wayfinding)


hud = HeadsUpDisplay.from_file(game, "game-data/hud/hud_config.yml")
game.hud = hud

menu_manager = MenuManager.new(game)
game.menu_manager = menu_manager

menu = Menu.from_file("test-data/menus/main.yml")
menu_manager.add_menu(game.main_menu_name, menu)


sm.play_song("music", true)
game.show

