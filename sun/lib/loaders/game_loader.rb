# To change this template, choose Tools | Templates
# and open the template in the editor.

class GameLoader
  def self.game_from_yaml(yaml)
    data = YAML.load(yaml)
    conf = data['game']

    game = Game.new({:width => conf['width'], :height => conf['height']})

    path_manager = PathFollowingManager.new(game)
    game.path_following_manager = path_manager
    game.collision_responder = YamlLoader.from_file(CollisionResponder, game, conf['collision_response'])
    game.load_level(conf['level'])
    game.input_manager = YamlLoader.from_file(InputManager, game, conf['input_manager'])

    p = YamlLoader.from_file(Player, game, conf['player'])
    game.sound_manager = YamlLoader.from_file(SoundManager, game, conf['sound_manager'])
    game.set_player(p)
    #TODO this is not right, should come from level/spawning
    #TODO massive hack, get rid of this ASAP
    if game.level.name !~ /load_screen/

      e = YamlLoader.from_file(Enemy, game, "game-data/enemies/enemy.yml")
      game.add_enemy(e)
      e.tracking_target = p
      path_manager.add_tracking(e, game.wayfinding)
    end


    hud = YamlLoader.from_file(HeadsUpDisplay, game, conf['heads_up_display'])
    game.hud = hud

    menu_manager = MenuManager.new(game)
    game.menu_manager = menu_manager

    menu = YamlLoader.from_file(Menu, game, "test-data/menus/main.yml")
    menu_manager.add_menu(game.main_menu_name, menu)
    

    game
  end
  
end
