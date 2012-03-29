# To change this template, choose Tools | Templates
# and open the template in the editor.

class InputManager
  def initialize(game)
    @game = game
    @keys = {}
  end
  @@UP = "Up"
  @@RIGHT = "Right"
  @@LEFT = "Left"
  @@DOWN = "Down"
  @@FIRE = "Fire"
  @@QUIT = "Quit"
  @@MENU = "Menu"
  @@MENU_ENTER = "MenuEnter"

  def respond_to_keys
    if @keys[@@QUIT]
      @game.deactivate_and_quit
    end

    if @keys[@@MENU]
      @game.enter_menu
    end

    
    if @game.menu_mode?
      if @keys[@@DOWN]
        @game.menu_manager.move_down
      end
      if @keys[@@MENU_ENTER]
        @game.menu_manager.invoke_current
      end

      @game.update_menu_state
      return
    end

    if @keys[@@RIGHT]
      @game.player.turn(@game.turn_speed)
    end
    if @keys[@@LEFT]
      @game.player.turn(-@game.turn_speed)
    end
    if @keys[@@UP]
      @game.player.move_forward(@game.movement_distance)
    end
    if @keys[@@DOWN]
      @game.player.move_forward(-@game.movement_distance)
    end
    if @keys[@@FIRE]
      @game.player.use_weapon
    end

  end

  def update_key_state

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      set_key_to_active(@@LEFT)
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      set_key_to_active(@@RIGHT)
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      set_key_to_active(@@UP)
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      set_key_to_active(@@DOWN)
    end
    if button_down? Gosu::KbSpace then
      set_key_to_active(@@FIRE)
    end
    if button_down? Gosu::KbEnter or button_down? Gosu::KbReturn then
      set_key_to_active(@@MENU_ENTER)
    end

    if button_down? Gosu::KbQ then
      set_key_to_active(@@QUIT)
    end

    if button_down? Gosu::KbM then
      set_key_to_active(@@MENU)
    end

    #if button_down? Gosu::KbA then
    #  toggle_enemy_ai
    #end
    if button_down? Gosu::KbA then
      toggle_enemy_ai
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
