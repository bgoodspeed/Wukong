# To change this template, choose Tools | Templates
# and open the template in the editor.

class GameLoader
  def self.game_from_yaml(yaml)
    data = YAML.load(yaml)
    conf = data['game']

    game = Game.new({:width => conf['width'], :height => conf['height']})
    game.log.info { "Building HUD: #{conf['heads_up_display']}"}
    hud = YamlLoader.from_file(HeadsUpDisplay, game, conf['heads_up_display'])
    game.hud = hud

    path_controller = PathFollowingController.new(game)
    game.path_following_controller = path_controller
    game.log.info { "Loading collision response: #{conf['collision_response']}"}
    game.collision_responder = YamlLoader.from_file(CollisionResponseController, game, conf['collision_response'])
    game.load_level(conf['level'])
    game.log.info { "Loading input controller: #{conf['input_controller']}"}
    game.input_controller = YamlLoader.from_file(InputController, game, conf['input_controller'])
    game.new_game_level = conf['new_game_level']
    game.log.info { "Loading player: #{conf['player']}"}
    p = YamlLoader.from_file(Player, game, conf['player'])
    game.log.info { "Building sound controller: #{conf['sound_controller']}"}
    game.sound_controller = YamlLoader.from_file(SoundController, game, conf['sound_controller'])
    game.set_player(p)
    #TODO this is not right, should come from level/spawning
    #TODO massive hack, get rid of this ASAP
    if game.level.name !~ /load_screen/
      game.log.info { "Adding hackish enemy "}
      e = YamlLoader.from_file(Enemy, game, "game-data/enemies/enemy.yml")
      game.add_enemy(e)
      e.tracking_target = p
      path_controller.add_tracking(e, game.wayfinding)
    end


    menu_controller = MenuController.new(game)
    game.menu_controller = menu_controller

    game.game_load_path = conf['game_load_path'] if conf['game_load_path']
    game.log.info { "Setting game load path : #{conf['game_load_path']}"}

    game.main_menu_name = try_add_menu(game, conf['menu_for_main'])
    game.menu_for_load_game = try_add_menu(game, conf['menu_for_load_game'])
    game.menu_for_save_game = try_add_menu(game, conf['menu_for_save_game'])
    game.game_over_menu = try_add_menu(game, conf['game_over_menu'])
    
    if conf['splash_screen']
      game.log.info { "Adding splash #{conf['splash_screen']}"}
      game.splash_controller.add_splash(conf['splash_screen'])
      game.splash_controller.splash_mode = true
    end

    game
  end

  def self.try_add_menu(game , menu_name)
    if menu_name
      game.log.info { "Adding menu #{menu_name}"}
      m = YamlLoader.from_file(Menu, game, menu_name)
      game.menu_controller.add_menu(menu_name, m)
    end
    menu_name
  end
  
end
