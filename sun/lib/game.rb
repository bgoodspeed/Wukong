# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'statemachine'

require 'utility_vector_math'
class Array
  include ArrayVectorOperations
end

require 'zorder'
require 'utility_drawing'
require 'spatial_hash'
require 'level'
require 'screen'
require 'weapon'
require 'player'
require 'enemy'
require 'clock'
require 'camera'
require 'heads_up_display'
require 'collision_responder'
require 'way_finding'
require 'artificial_intelligence'
require 'animation_manager'
require 'path_following_manager'
require 'loaders/player_loader'
require 'loaders/level_loader'
require 'death_event'



class Game

  attr_accessor :player, :clock, :hud, :animation_manager, :turn_speed,
    :movement_distance, :path_following_manager, :enemy, :events, :camera,
    :screen

  def initialize(deps = {})
    dependencies = {:framerate => 60}.merge(deps)
    @screen = Screen.new(self, dependencies[:width], dependencies[:height])
    @player_loader = PlayerLoader.new(self)
    @level_loader = LevelLoader.new(self)
    @collision_responder = CollisionResponder.new(self)
    @animation_manager = AnimationManager.new(self)
    @path_following_manager = PathFollowingManager.new(self)
    @camera = Camera.new(self)
    @keys = {}
    @events = []
    @active = true
    @clock = Clock.new(dependencies[:framerate])
    @hud = HeadsUpDisplay.new(self)
  end

  def load_level(level_name)
    @level = @level_loader.load_level(level_name)
    @player = @player_loader.load_player
    @level.add_player(@player)
    @level
  end

  def set_player(player)
    @player = player
    @level.set_player(player)

  end

  #TNT set_enemy
  def set_enemy(enemy)
    @enemy = enemy
    @level.set_enemy(enemy)
  end

  def remove_enemy(enemy)
    @enemy = nil
    @level.remove_enemy(enemy)
  end

  def add_death_event(who)
    @events << DeathEvent.new(who)
  end
  def load_animation(entity, name, animation, w, h, tiles)
    @animation_manager.load_animation(entity, name, animation, w, h, tiles)
  end

  def set_screen_size(width, height)
    @screen.set_size(width, height)
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

  #TODO abstract these somewhere
  @@UP = "Up"
  @@RIGHT = "Right"
  @@LEFT = "Left"
  @@DOWN = "Down"
  @@FIRE = "Fire"
  @@QUIT = "Quit"
  @@TURN_SPEED = 90
  @@MOVEMENT_DISTANCE = 1
  
  def turn_speed
    @turn_speed.nil? ? @@TURN_SPEED : @turn_speed
  end

  def movement_distance
    @movement_distance.nil? ? @@MOVEMENT_DISTANCE : @movement_distance
  end


  def update_game_state
    if @keys[@@QUIT]
      @active = false
      @screen.close
    end

    @events.each{|event| 
      raise "unkown event type #{event}" unless event.kind_of? DeathEvent
      remove_enemy(event.who)
    }

    if @keys[@@RIGHT]
      @player.turn(turn_speed)
    end
    if @keys[@@LEFT]
      @player.turn(-turn_speed)
    end
    if @keys[@@UP]
      @player.move_forward(movement_distance)
    end
    if @keys[@@DOWN]
      @player.move_forward(-movement_distance)
    end
    if @keys[@@FIRE]
      @player.use_weapon
    end


    @animation_manager.tick
    @path_following_manager.tick
    collisions = @level.check_for_collisions

    @collision_responder.handle_collisions(collisions)

  end

  def button_down?(button)
    @screen.button_down?(button)
  end

  #TODO hackish :(
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

    if button_down? Gosu::KbQ then
      set_key_to_active(@@QUIT)
    end

  end

  def render_one_frame

    @level.draw(@screen)
    @hud.draw(@screen)
    @animation_manager.draw(@screen)
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
  def player_position
    @player.position
  end

  def capture_screenshot(name)
    @screen.draw
    @screen.flush
    @screen.capture_screenshot(name)
  end

  def dynamic_elements
    @level.dynamic_elements
  end
  def window
    @screen.window
  end
  def show
    @screen.show
  end

  def weapon_in_use?
    @player.weapon_in_use?
  end
  def update_all
    @clock.tick
    clear_keys
    update_key_state
    update_game_state

  end
  def simulate
    update_all
    draw
    #TODO bad fit this should be managed by the animation mgr?
    if weapon_in_use?
      @player.draw_weapon
    end
    while @clock.current_frame_too_fast? do
      # TODO NOOP, could sleep to free up CPU cycles
    end
  end

  def camera_position
    @camera.position
  end

  def active?
    @active
  end

end
