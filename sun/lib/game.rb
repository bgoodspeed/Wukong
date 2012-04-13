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

require 'yaml_helper'
require 'graphics'
require 'loaders/game_loader'
require 'loaders/yaml_loader'
require 'zorder'
require 'utility_drawing'
require 'managers/event_manager'
require 'spawn_point'
require 'managers/image_manager'
require 'managers/completion_manager'
require 'mouse_collision_wrapper'
require 'event_emitter'
require 'collider'
require 'spatial_hash'
require 'managers/menu_manager'
require 'managers/condition_manager'
require 'level'
require 'screen'
require 'weapon'
require 'player'
require 'enemy'
require 'clock'
require 'camera'
require 'heads_up_display'
require 'managers/action_manager'
require 'collision_responder'
require 'way_finding'
require 'artificial_intelligence'
require 'managers/input_manager'
require 'managers/animation_manager'
require 'vector_follower'
require 'managers/path_following_manager'

require 'timed_event'
require 'event_area'
require 'loaders/player_loader'
require 'loaders/level_loader'
require 'loaders/save_loader'

require 'managers/sound_manager'
require 'managers/splash_manager'



require 'forwardable'
class Game
  extend Forwardable
  
  attr_accessor :player, :clock, :hud, :animation_manager, :turn_speed,
    :movement_distance, :path_following_manager, :enemy, :camera,
    :screen, :level, :sound_manager, :collision_responder, :collisions,
    :wayfinding, :menu_manager, :main_menu_name, :input_manager,
    :temporary_message, :mouse_drawn, :event_manager, :image_manager, 
    :action_manager, :condition_manager, :completion_manager, :active, 
    :new_game_level, :menu_for_load_game, :game_load_path, :splash_manager, 
    :over, :game_over_menu, :menu_for_save_game, :log

  alias_method :active?, :active

  def_delegators :@player, :turn_speed, :movement_distance, :weapon_in_use?
  def_delegators :@level, :add_enemy, :enemies, :dynamic_elements
  def_delegators :@event_manager, :add_event, :events
  def_delegators :@menu_manager, :current_menu_index
  def_delegators :@animation_manager, :load_animation
  def_delegators :@input_manager, :enable_action, :disable_action, :event_enabled?
  def_delegators :@sound_manager, :play_effect
  def_delegators :@splash_manager, :splash_mode
  def_delegators :@screen, :window, :show
  def_delegator:@screen, :set_size, :set_screen_size
  def_delegator:@menu_manager, :active?, :menu_mode?
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
    @action_manager = ActionManager.new(self)
    @image_manager = ImageManager.new(self)
    @player_loader = PlayerLoader.new(self)
    @level_loader = LevelLoader.new(self)
    @collision_responder = CollisionResponder.new(self)
    @animation_manager = AnimationManager.new(self)
    @path_following_manager = PathFollowingManager.new(self)
    @menu_manager = MenuManager.new(self)
    @condition_manager = ConditionManager.new(self)
    @completion_manager = CompletionManager.new(self)
    @input_manager = InputManager.new(self)
    @event_manager = EventManager.new(self)
    @camera = Camera.new(self)
    @mouse_drawn = true
    @main_menu_name = "main menu"
    @game_load_path = "UNSET"
    @active = true
    @over = false 
    @clock = Clock.new(self, dependencies[:framerate])
    @hud = HeadsUpDisplay.new(self)
    @sound_manager = SoundManager.new(self)
    @splash_manager = SplashManager.new(self)
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
      @sound_manager.play_song(@level.background_music, true)
    end
    @clock.reset
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
    vf = @path_following_manager.add_projectile(start, theta, vel)
    @level.add_projectile(vf)
    vf
  end

  def remove_projectile(projectile)
    @path_following_manager.remove_projectile(projectile)
    @level.remove_projectile(projectile)
    @player.inactivate_weapon
  end

  def draw
    render_one_frame
  end

  def update_menu_state
    @hud.clear
    @menu_manager.current_menu_lines.each {|line|  @hud.add_line(line)}
  end

  def deactivate_and_quit
    @active = false
    @screen.close
  end

  def update_game_state
    
    @event_manager.handle_events
    @input_manager.respond_to_keys
    @animation_manager.tick
    @path_following_manager.tick
    @level.tick
    @collisions = @level.check_for_collisions
    @collision_responder.handle_collisions(@collisions)
  end

  def render_one_frame
    if @splash_manager.splash_mode
      @splash_manager.draw(@screen)
      return
    end

    @level.draw(@screen)
    @animation_manager.draw(@screen)
    @hud.draw(@screen)

    #TODO HACK
    if @input_manager.mouse_on_screen && @mouse_drawn
      @screen.draw_crosshairs_at(@input_manager.mouse_screen_coords)
    end

  end

  def capture_screenshot(name)
    @screen.draw
    @screen.flush
    @screen.capture_screenshot(name)
  end

  def update_all
    @clock.tick
    @input_manager.clear_keys
    @input_manager.update_key_state

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
    @menu_manager.activate(name)
    @hud.menu_mode = true
    @hud.swap_copy
  end
  
  def exit_menu
    @menu_manager.inactivate
    @hud.menu_mode = false
    @hud.swap
  end

  #TODO make wiki note that screen coords are top left to bottom right

  def pick_game_element
    @level.add_mouse(@input_manager.mouse_screen_coords)
  end

  def interact
    @level.interact(@player.to_collision)
  end

  def noop(arg=nil)
    #NOOP
  end
end
