# To change this template, choose Tools | Templates
# and open the template in the editor.

class GameLoader
  extend YamlHelper
  def self.menus
    [['main_menu_name', 'menu_for_main'],
     ['menu_for_load_game', 'menu_for_load_game'],
     ['menu_for_save_game', 'menu_for_save_game'],
     ['game_over_menu', 'game_over_menu']]
  end
  def self.process_menu(game, conf, m)
    game.send("#{m[0]}=", try_add_menu(game, conf[m[1]]))
  end
  def self.game_constructed_deps
    [
      ['path_following_controller', PathFollowingController],
      ['menu_controller', MenuController],
    ]
  end

  def self.process_game_constructed_dep(game, d)
    game.send("#{d[0]}=", d[1].new(game))
  end

  def self.sub_yaml_deps_pre_level
    [
      ['input_controller', InputController, 'input_controller'],
      ['collision_response_controller', CollisionResponseController, 'collision_response'],
      ['sound_controller', SoundController, 'sound_controller'],
      ['inventory_controller', InventoryController, 'inventory'],
      ['hud', HeadsUpDisplay, 'heads_up_display']
    ]
  end

  def self.sub_yaml_deps_post_level
    [
      ['player', Player, 'player', 'set_player'],
      
    ]
  end
  def self.process_yaml_dep(game, conf, cf)
    game.log.info { "Loading #{cf} from #{conf}"}
    return unless conf[cf[2]]
    if cf.size > 3
      game.send(cf[3], YamlLoader.from_file(cf[1], game, conf[cf[2]]))
    else
      game.send("#{cf[0]}=", YamlLoader.from_file(cf[1], game, conf[cf[2]]))
    end
  end

  def self.attributes
    [
      'new_game_level', 'game_load_path', 'menu_for_equipment'
    ]
  end
  extend ValidationHelper

  def self.game_from_yaml(yaml, f="unknown")
    data = YAML.load(yaml)
    conf = data['game']

    game = Game.new({:width => conf['width'], :height => conf['height']})
    game.log.info { "Building HUD: #{conf['heads_up_display']}"}
    game_constructed_deps.each {|d| process_game_constructed_dep(game,  d)}

    process_attributes(attributes, game, conf)
    menus.each {|m| process_menu(game, conf, m)}
    sub_yaml_deps_pre_level.each {|a| process_yaml_dep(game, conf, a)}
    game.load_level(conf['level'])
    sub_yaml_deps_post_level.each {|a| process_yaml_dep(game, conf, a)}

    try_add_splash_screen(game, conf)
    try_add_font_config(game, conf)
    @game = game
    @which_level = f
    check_validation_error(game, "Fix game yaml", game.required_attributes)
    game
  end



  def self.try_add_font_config(game, conf)
    if conf['font_config']
      game.font_controller = FontController.new(game, conf['font_config']['font_name'], conf['font_config']['font_size'])
    end
  end
  def self.try_add_splash_screen(game, conf)
    if conf['splash_screen']
      game.log.info { "Adding splash #{conf['splash_screen']}"}
      game.splash_controller.add_splash(conf['splash_screen'])
      game.splash_controller.splash_mode = true
    end

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
