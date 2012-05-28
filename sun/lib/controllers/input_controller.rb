# To change this template, choose Tools | Templates
# and open the template in the editor.

module KeyActions
  UP = "Up"
  RIGHT = "Right"
  LEFT = "Left"
  DOWN = "Down"
  FIRE = "Fire"
  INTERACT = "Interact"
  TARGETTING = "Targetting"
  EXIT_TARGETTING = "ExitTargetting"

  QUIT = "Quit"
  MENU = "Menu"
  MENU_ENTER = "MenuEnter"
  MOUSE_CLICK = "MouseClick"
end

module BehaviorPriority
  LOW = 100
  MED = 0
  HIGH = -100
end

class InputController
  attr_accessor :keyboard, :gamepad


  def self.default_keyboard_config
    { Graphics::KbLeft => KeyActions::LEFT,
      Graphics::KbRight => KeyActions::RIGHT,
      Graphics::KbUp => KeyActions::UP,
      Graphics::KbDown => KeyActions::DOWN,
      Graphics::KbSpace => KeyActions::FIRE,
      Graphics::KbEnter => KeyActions::MENU_ENTER,
      Graphics::KbReturn => KeyActions::MENU_ENTER,
      Graphics::KbM => KeyActions::MENU,
      Graphics::KbO => KeyActions::INTERACT,
      Graphics::KbQ => KeyActions::QUIT,
      Graphics::KbT => KeyActions::TARGETTING,
      Graphics::KbX => KeyActions::EXIT_TARGETTING
    }

  end
  def self.default_gamepad_config
    { Graphics::GpLeft => KeyActions::LEFT,
      Graphics::GpRight => KeyActions::RIGHT,
      Graphics::GpUp => KeyActions::UP,
      Graphics::GpDown => KeyActions::DOWN }
  end
  def self.default_mouse_config
    { Graphics::MsLeft => KeyActions::MOUSE_CLICK,}
  end

  attr_reader :keyboard, :disabled
  #TODO abstract these into yml ?
  def initialize(game, keyboard_conf = InputController.default_keyboard_config, gamepad_conf = InputController.default_gamepad_config, mouse_conf = InputController.default_mouse_config)
    @game = game
    @keys = {}
    @keyboard = keyboard_conf
    @gamepad = gamepad_conf
    @mouse = mouse_conf
    #TODO could go into a key repeat controller or something like that
    @disabled = {}
    @behavior_priority_overrides = {
        KeyActions::TARGETTING => BehaviorPriority::LOW,
        KeyActions::LEFT => BehaviorPriority::MED,
        KeyActions::RIGHT => BehaviorPriority::MED,
        KeyActions::UP => BehaviorPriority::HIGH,
        KeyActions::DOWN => BehaviorPriority::HIGH,
    }
  end

  def mouse_world_coordinates
    msc = mouse_screen_coords
    @game.camera.world_coordinates_for(msc)
  end


  def mouse_screen_coords
    GVector.xy(@game.window.mouse_x, @game.window.mouse_y)
  end

  def mouse_on_screen
    msc = mouse_screen_coords
    return false if msc.x <= 0
    return false if msc.x > @game.screen.width
    return false if msc.y <= 0
    return false if msc.y > @game.screen.height
    true
  end

  def behavior_priority(behavior)
    return 0 unless @behavior_priority_overrides.has_key?(behavior)
    @behavior_priority_overrides[behavior]
  end

  def run_activated(behaviors)
    ordered_behaviors = behaviors.keys.sort {|a,b| behavior_priority(a) <=> behavior_priority(b)}
    ordered_behaviors.each { |action|
      behavior = behaviors[action]
      if @keys[action] && !@disabled[action]
        behavior.call(@game, nil)
      end
    }
  end

  def respond_to_keys
    if @game.splash_mode
      @game.splash_controller.splash_mode = false unless @keys.empty?
      return
    end

    run_activated @game.action_controller.always_available_behaviors
    if @game.targetting_controller.active
      run_activated @game.action_controller.targetting_behaviors
      return
    end

    if @game.menu_mode?
      run_activated @game.action_controller.menu_behaviors
      if @game.menu_mode?  #TODO ugly, second call because menu behaviors can turn this off
        @game.update_menu_state
      end
      return
    end

    run_activated @game.action_controller.gameplay_behaviors

  end


  def button_mappings
    @mouse.merge(@gamepad.merge(@keyboard))
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
    @last_keys = @keys
    @keys = {}
  end

  def enable_all
    @disabled = {}
  end
  def enable_action(action)
    @disabled[action] = false
  end
  def disable_action(action)
    @disabled[action] = true
  end

  def event_enabled?(action)
    !@disabled[action]
  end

end
