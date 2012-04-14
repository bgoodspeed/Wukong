# To change this template, choose Tools | Templates
# and open the template in the editor.

require "logger"
require 'statemachine'

require 'utility_vector_math'

class Array
  include ArrayVectorOperations
end

require 'behaviors/movement_undoable'
require 'behaviors/health'
require 'behaviors/collidable'
require 'controllers/game_item_controller'
require 'yaml_helper'
require 'graphics'
require 'loaders/game_loader'
require 'loaders/yaml_loader'
require 'zorder'
require 'utility_drawing'
require 'controllers/event_controller'
require 'spawn_point'
require 'controllers/image_controller'
require 'controllers/completion_controller'
require 'mouse_collision_wrapper'
require 'event_emitter'
require 'collider'
require 'spatial_hash'
require 'controllers/menu_controller'
require 'controllers/condition_controller'
require 'level'
require 'screen'
require 'weapon'
require 'player'
require 'enemy'
require 'clock'
require 'camera'
require 'heads_up_display'
require 'controllers/action_controller'
require 'collision_responder'
require 'way_finding'
require 'artificial_intelligence'
require 'controllers/input_controller'
require 'controllers/animation_controller'
require 'vector_follower'
require 'controllers/path_following_controller'

require 'timed_event'
require 'event_area'
require 'loaders/player_loader'
require 'loaders/level_loader'
require 'loaders/save_loader'

require 'controllers/sound_controller'
require 'controllers/splash_controller'



require 'forwardable'
class Game
  extend Forwardable
  
  attr_accessor :player, :clock, :hud, :animation_controller, :turn_speed,
    :movement_distance, :path_following_controller, :enemy, :camera,
    :screen, :level, :sound_controller, :collision_responder, :collisions,
    :wayfinding, :menu_controller, :main_menu_name, :input_controller,
    :temporary_message, :mouse_drawn, :event_controller, :image_controller, 
    :action_controller, :condition_controller, :completion_controller, :active, 
    :new_game_level, :menu_for_load_game, :game_load_path, :splash_controller, 
    :over, :game_over_menu, :menu_for_save_game, :log, :game_item_controller

  alias_method :active?, :active

  def_delegators :@player, :turn_speed, :movement_distance, :weapon_in_use?
  def_delegators :@level, :add_enemy, :enemies, :dynamic_elements
  def_delegators :@event_controller, :add_event, :events
  def_delegators :@menu_controller, :current_menu_index
  def_delegators :@animation_controller, :load_animation
  def_delegators :@input_controller, :enable_action, :disable_action, :event_enabled?
  def_delegators :@sound_controller, :play_effect
  def_delegators :@splash_controller, :splash_mode
  def_delegators :@screen, :window, :show
  def_delegator:@screen, :set_size, :set_screen_size
  def_delegator:@menu_controller, :active?, :menu_mode?
  def_delegator:@player, :position, :player_position
  def_delegator:@camera, :position, :camera_position
  def_delegator:@level, :remove_mouse, :remove_mouse_collision
  
  def initialize(deps = {})
    dependencies = {:framerate => 60}.merge(deps)
    #TODO HACKISH
    log_path = "logs"
    Dir.mkdir(log_path) unless File.exists?(log_path)
    @log = Logger.new(File.join(log_path, "game.log"), 10, 1024000)
    @log.level = Logger::INFO #NOTE: also ::DEBUG 
    @screen = Screen.new(self, dependencies[:width], dependencies[:height])
    @game_item_controller = GameItemController.new(self)
    @action_controller = ActionController.new(self)
    @image_controller = ImageController.new(self)
    @player_loader = PlayerLoader.new(self)
    @level_loader = LevelLoader.new(self)
    @collision_responder = CollisionResponder.new(self)
    @animation_controller = AnimationController.new(self)
    @path_following_controller = PathFollowingController.new(self)
    @menu_controller = MenuController.new(self)
    @condition_controller = ConditionController.new(self)
    @completion_controller = CompletionController.new(self)
    @input_controller = InputController.new(self)
    @event_controller = EventController.new(self)
    @camera = Camera.new(self)
    @mouse_drawn = true
    @main_menu_name = "main menu"
    @game_load_path = "UNSET"
    @active = true
    @over = false 
    @clock = Clock.new(self, dependencies[:framerate])
    @hud = HeadsUpDisplay.new(self)
    @sound_controller = SoundController.new(self)
    @splash_controller = SplashController.new(self)
    @save_loader = SaveLoader.new(self)
    @collisions = []
  end

  def load_game_slot(slot)
    @save_loader.load_slot(slot)
  end
  def save_game_slot(slot)
    @save_loader.save_slot(slot)
  end

  def load_level(level_name)
    @level = @level_loader.load_level(level_name)
    if !@player
      @player = @player_loader.load_player
    end
    @level.add_player(@player)
    if @level.background_music
      @sound_controller.play_song(@level.background_music, true)
    end
    @clock.reset
    @input_controller.enable_all
    @level
  end

  def set_player(player)
    @player = player
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
    @animation_controller.tick
    @path_following_controller.tick
    @level.tick
    @collisions = @level.check_for_collisions
    @collision_responder.handle_collisions(@collisions)
  end

  def render_one_frame
    if @splash_controller.splash_mode
      @splash_controller.draw(@screen)
      return
    end

    @level.draw(@screen)
    @animation_controller.draw(@screen)
    @hud.draw(@screen)

    #TODO HACK
    if @input_controller.mouse_on_screen && @mouse_drawn
      @screen.draw_crosshairs_at(@input_controller.mouse_screen_coords)
    end

  end

  def capture_screenshot(name)
    @screen.draw
    @screen.flush
    @screen.capture_screenshot(name)
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
  def enter_menu(name=@main_menu_name)
    @menu_controller.activate(name)
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

  def noop(arg=nil)
    #NOOP
  end
end
