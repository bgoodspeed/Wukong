# To change this template, choose Tools | Templates
# and open the template in the editor.

require "logger"
require 'statemachine'
require 'models/collision_priority'
require 'utility/utility_vector_math'

class Array
  include ArrayVectorOperations
end

require 'helpers/init_helper'
require 'behaviors/movement_undoable'
require 'behaviors/health'
require 'behaviors/collidable'
require 'behaviors/game_line_formattable'
require 'controllers/game_item_controller'
require 'helpers/yaml_helper'
require 'utility/graphics'
require 'loaders/game_loader'
require 'loaders/yaml_loader'
require 'models/zorder'

require 'utility/utility_drawing'
require 'models/menu'
require 'controllers/event_controller'
require 'models/spawn_point'
require 'controllers/image_controller'
require 'controllers/completion_controller'
require 'models/mouse_collision_wrapper'
require 'models/event_emitter'
require 'models/collider'
require 'models/spatial_hash'
require 'models/inventory'
require 'controllers/inventory_controller'
require 'controllers/rendering_controller'
require 'controllers/menu_controller'
require 'controllers/condition_controller'
require 'controllers/font_controller'
require 'models/level'
require 'models/screen'
require 'models/weapon'
require 'models/player'
require 'models/enemy'
require 'models/clock'
require 'models/camera'
require 'models/heads_up_display'
require 'models/info_window'
require 'controllers/action_controller'
require 'controllers/collision_response_controller'
require 'models/way_finding'
require 'models/artificial_intelligence'
require 'controllers/input_controller'
require 'controllers/animation_controller'
require 'models/vector_follower'
require 'controllers/path_following_controller'

require 'models/timed_event'
require 'models/event_area'
require 'loaders/player_loader'
require 'loaders/level_loader'
require 'loaders/save_loader'

require 'controllers/sound_controller'
require 'controllers/splash_controller'
require 'controllers/targetting_controller'
require 'controllers/level_controller'



require 'forwardable'
class Game
  extend Forwardable
  GAME_CONSTRUCTED = [ :game_item_controller, :animation_controller,
    :action_controller, :image_controller, :player_loader, :level_loader,
    :rendering_controller, :path_following_controller, :menu_controller,
    :condition_controller, :completion_controller, :event_controller,
    :input_controller, :camera, :splash_controller, :sound_controller, 
    :save_loader, :font_controller, :inventory_controller, :level_controller,
    :collision_response_controller, :targetting_controller
  ]
  attr_accessor :player, :clock, :hud, :screen, :level, :collisions,
    :wayfinding, :main_menu_name, :temporary_message, :mouse_drawn,
    :active, :new_game_level, :menu_for_load_game, :game_load_path, :over,
    :game_over_menu, :menu_for_save_game, :log, :menu_for_equipment,
    :old_level_name

  ATTRIBUTES = GAME_CONSTRUCTED
  ATTRIBUTES.each {|attr| attr_accessor attr}
  
  alias_method :active?, :active

  def_delegators :@player, :turn_speed, :movement_distance, :weapon_in_use?, :stop_weapon
  def_delegators :@level, :add_enemy, :enemies, :dynamic_elements
  def_delegators :@event_controller, :add_event, :events
  def_delegators :@level_controller, :load_level
  def_delegators :@menu_controller, :current_menu_index
  def_delegators :@animation_controller, :load_animation
  def_delegators :@input_controller, :enable_action, :disable_action, :event_enabled?
  def_delegators :@sound_controller, :play_effect
  def_delegators :@splash_controller, :splash_mode
  def_delegators :@screen, :window, :show
  def_delegator :@screen, :set_size, :set_screen_size
  def_delegator :@menu_controller, :active?, :menu_mode?
  def_delegator :@player, :position, :player_position
  def_delegator :@camera, :position, :camera_position
  def_delegator :@level, :remove_mouse, :remove_mouse_collision
  def_delegator :@save_loader, :load_slot, :load_game_slot
  def_delegator :@save_loader, :save_slot, :save_game_slot

  include InitHelper

  def initialize(deps = {})
    dependencies = {:framerate => 60}.merge(deps)
    #TODO HACKISH
    log_path = "logs"
    Dir.mkdir(log_path) unless File.exists?(log_path)
    @log = Logger.new(File.join(log_path, "game.log"), 10, 1024000)
    @log.level = Logger::INFO #NOTE: also ::DEBUG 
    @screen = Screen.new(self, dependencies[:width], dependencies[:height])
    init_game_constructed(GAME_CONSTRUCTED, self)
    @mouse_drawn = true
    @main_menu_name = "main menu"
    @menu_for_equipment = GameMenu::EQUIPMENT
    @game_load_path = "UNSET"
    @old_level_name = nil
    @active = true
    @over = false 
    @clock = Clock.new(self, dependencies[:framerate])
    @hud = HeadsUpDisplay.new(self)
    @collisions = []
  end

  def set_player(player)
    @log.info "Setting player #{player}"
    @player = player
    #TODO Hackish and an exact double
    if @level.player_start_position
      @player.position = @level.player_start_position
    end
    @level.set_player(player)

  end

  def remove_enemy(enemy)
    #TODO get rid of this @enemy var
    @enemy = nil
    @level.remove_enemy(enemy)
  end

  def add_projectile(start, theta, vel)
    vf = @path_following_controller.add_projectile(start, theta, vel)
    @level.add_projectile(vf)
    vf
  end

  def remove_projectile(projectile)
    @path_following_controller.remove_projectile(projectile)
    @level.remove_projectile(projectile)
    @player.inactivate_weapon
  end

  def draw
    render_one_frame
  end

  def update_menu_state
    @hud.clear

    @menu_controller.current_menu_lines.each {|line|  @hud.add_line(line)}
  end

  def deactivate_and_quit
    @active = false
    @screen.close
  end

  def update_game_state
    
    @event_controller.handle_events
    @input_controller.respond_to_keys
    return if menu_mode? 
    @animation_controller.tick
    @path_following_controller.tick
    @level.tick
    @collisions = @level.check_for_collisions
    @collision_response_controller.handle_collisions(@collisions)
  end

  def render_one_frame
    if @splash_controller.splash_mode
      @splash_controller.draw(@screen)
      return
    end

    @level.draw(@screen)
    @animation_controller.draw(@screen)
    
    if menu_mode?
      @menu_controller.draw(@screen)
    else
      @hud.draw(@screen)
    end

    #TODO HACK
    if @input_controller.mouse_on_screen && @mouse_drawn
      @screen.draw_crosshairs_at(@input_controller.mouse_screen_coords)
    end

  end

  def update_all
    @clock.tick
    @input_controller.clear_keys
    @input_controller.update_key_state

    update_game_state
    remove_mouse_collision
  end
  
  def simulate
    update_all
    draw
    while @clock.current_frame_too_fast? do
    #  puts "looping"
      # TODO NOOP, could sleep to free up CPU cycles
    end
  end
  def enter_menu(name=@main_menu_name, filter=nil)
    @menu_controller.activate(name, filter)
    @hud.menu_mode = true
    @hud.swap_copy
  end
  
  def exit_menu
    @menu_controller.inactivate
    @hud.menu_mode = false
    @hud.swap
  end

  #TODO make wiki note that screen coords are top left to bottom right

  def pick_game_element
    @level.add_mouse(@input_controller.mouse_screen_coords)
  end

  def interact
    @level.interact(@player.to_collision)
  end

  def last_save_time_for_slot(slot)
    d = File.join(@game_load_path, slot.to_s)
    return "(empty)" unless Dir.exists?(d)
    t = File.mtime(File.join(d, "savedata.yml"))
    "(#{t})"
  end

  def noop(arg=nil)
    #NOOP
  end
end
