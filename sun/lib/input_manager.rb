# To change this template, choose Tools | Templates
# and open the template in the editor.

module KeyActions
  UP = "Up"
  RIGHT = "Right"
  LEFT = "Left"
  DOWN = "Down"
  FIRE = "Fire"
  QUIT = "Quit"
  MENU = "Menu"
  MENU_ENTER = "MenuEnter"
end

class InputManager
  attr_accessor :keyboard, :gamepad
  def self.default_keyboard_config
    { Gosu::KbLeft => KeyActions::LEFT,
      Gosu::KbRight => KeyActions::RIGHT,
      Gosu::KbUp => KeyActions::UP,
      Gosu::KbDown => KeyActions::DOWN,
      Gosu::KbSpace => KeyActions::FIRE,
      Gosu::KbEnter => KeyActions::MENU_ENTER,
      Gosu::KbReturn => KeyActions::MENU_ENTER,
      Gosu::KbM => KeyActions::MENU,
      Gosu::KbQ => KeyActions::QUIT }

  end
  def self.default_gamepad_config
    { Gosu::GpLeft => KeyActions::LEFT,
      Gosu::GpRight => KeyActions::RIGHT,
      Gosu::GpUp => KeyActions::UP,
      Gosu::GpDown => KeyActions::DOWN }
  end

  #TODO abstract these into yml ?
  def initialize(game, keyboard_conf = InputManager.default_keyboard_config, gamepad_conf = InputManager.default_gamepad_config)
    @game = game
    @keys = {}
    @keyboard = keyboard_conf
    @gamepad = gamepad_conf

    #TODO how to make this configurable? maybe not needed since input->action is configurable
    @always_available_behaviors = {
      KeyActions::QUIT => lambda { @game.deactivate_and_quit },
    }
    @gameplay_behaviors = {
      KeyActions::MENU => lambda { @game.enter_menu },
      KeyActions::RIGHT => lambda { @game.player.turn(@game.turn_speed) },
      KeyActions::LEFT => lambda { @game.player.turn(-@game.turn_speed) },
      KeyActions::UP => lambda { @game.player.move_forward(@game.movement_distance) },
      KeyActions::DOWN => lambda { @game.player.move_forward(-@game.movement_distance) },
      KeyActions::FIRE => lambda { @game.player.use_weapon },
    }

    @menu_behaviors = {
      KeyActions::DOWN => lambda { @game.menu_manager.move_down},
      KeyActions::MENU_ENTER => lambda { @game.menu_manager.invoke_current}
    }

  end

  def run_activated(behaviors)
    behaviors.each { |action, behavior| behavior.call if @keys[action] }
  end

  def respond_to_keys

    run_activated @always_available_behaviors
    
    if @game.menu_mode?
      run_activated @menu_behaviors
      @game.update_menu_state
      return
    end

    run_activated @gameplay_behaviors

  end


  def button_mappings
    @gamepad.merge(@keyboard)
  end

  def update_key_state
    button_mappings.each do |btn, mapping|
      set_key_to_active(mapping) if button_down? btn
    end
  end

  def button_down?(button)
    @game.screen.button_down?(button)
  end

  def set_key_to_active(key)
    @keys[key] = true
  end
  def active_keys
    @keys
  end
  def clear_keys
    @keys = {}
  end

end
