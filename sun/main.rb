# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"

game = Game.new({:width => 640, :height => 480})
path_manager = PathFollowingManager.new(game)
game.path_following_manager = path_manager
cr = YamlLoader.from_file(CollisionResponder, game, "test-data/collision_response/collision_response.yml")
game.collision_responder = cr
#game.load_level("test-data/levels/large/large.yml")
game.load_level("game-data/levels/demo/demo.yml")
im = YamlLoader.from_file(InputManager, game, "test-data/input/input_config.yml")
game.input_manager = im
p = YamlLoader.from_file(Player, game, "game-data/players/player.yml")


sm = YamlLoader.from_file(SoundManager, game, "game-data/sounds/sound_config.yml")
game.sound_manager = sm
game.set_player(p)
e = YamlLoader.from_file(Enemy, game, "game-data/enemies/enemy.yml")
game.add_enemy(e)
e.tracking_target = p
path_manager.add_tracking(e, game.wayfinding)


hud = YamlLoader.from_file(HeadsUpDisplay, game, "game-data/hud/hud_config.yml")
game.hud = hud

menu_manager = MenuManager.new(game)
game.menu_manager = menu_manager

menu = YamlLoader.from_file(Menu, game, "test-data/menus/main.yml")
menu_manager.add_menu(game.main_menu_name, menu)


sm.play_song("music", true)
game.show

