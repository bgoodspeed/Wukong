# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'statemachine'

require 'utility_vector_math'

class Array
  include ArrayVectorOperations
end

require 'yaml_helper'
require 'zorder'
require 'utility_drawing'
require 'event_emitter'
require 'spatial_hash'
require 'menu_manager'
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
require 'input_manager'
require 'animation_manager'
require 'path_following_manager'
require 'timed_event'

require 'loaders/player_loader'
require 'loaders/level_loader'

require 'death_event'
require 'sound_manager'



class Game

  attr_accessor :player, :clock, :hud, :animation_manager, :turn_speed,
    :movement_distance, :path_following_manager, :enemy, :events, :camera,
    :screen, :level, :sound_manager, :collision_responder, :collisions,
    :wayfinding, :menu_manager, :main_menu_name, :input_manager,
    :temporary_message, :mouse_drawn

  def initialize(deps = {})
    dependencies = {:framerate => 60}.merge(deps)
    @screen = Screen.new(self, dependencies[:width], dependencies[:height])
    @player_loader = PlayerLoader.new(self)
    @level_loader = LevelLoader.new(self)
    @collision_responder = CollisionResponder.new(self)
    @animation_manager = AnimationManager.new(self)
    @path_following_manager = PathFollowingManager.new(self)
    @menu_manager = MenuManager.new(self)
    @input_manager = InputManager.new(self)
    @camera = Camera.new(self)
    @mouse_drawn = true
    @main_menu_name = "main menu"
    @events = []
    @active = true
    @clock = Clock.new(self, dependencies[:framerate])
    @hud = HeadsUpDisplay.new(self)
    @sound_manager = SoundManager.new(self)
    @collisions = []
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

  def add_enemy(enemy)
    @level.add_enemy(enemy)
  end

  def enemies
    @level.enemies
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
  @@TURN_SPEED = 90
  @@MOVEMENT_DISTANCE = 1
  
  def turn_speed
    #@turn_speed.nil? ? @@TURN_SPEED : @turn_speed
    @player.turn_speed
    
  end

  def movement_distance
    #@movement_distance.nil? ? @@MOVEMENT_DISTANCE : @movement_distance
    @player.movement_distance
  end

  def update_menu_state
    @hud.clear
    @menu_manager.current_menu_lines.each {|line|  @hud.add_line(line)}

  end

  def deactivate_and_quit
    @active = false
    @screen.close
  end

  def menu_mode?
    @menu_manager.active?
  end

  #TODO this is getting messy 2nd TODO really messy
  def update_game_state
    @events.each{|event|
      raise "unkown event type #{event}" unless event.kind_of? DeathEvent
      remove_enemy(event.who)
    }
    
    @input_manager.respond_to_keys




    @animation_manager.tick
    @path_following_manager.tick
    
    @collisions = @level.check_for_collisions

    @collision_responder.handle_collisions(@collisions)

  end


  #TODO temporary hack throwaway
  def toggle_enemy_ai
    if @ai_on
      puts "turning off ai"
      @path_following_manager.remove_tracking(@enemy, @wayfinding)
      @ai_on = false
    else
      puts "turning on ai"
      @enemy.tracking_target = @player
      @path_following_manager.add_tracking(@enemy, @wayfinding)
      @ai_on = true

    end
  end

  


  def render_one_frame

    @level.draw(@screen)
    @animation_manager.draw(@screen)
    @hud.draw(@screen)

    #TODO HACK
    if mouse_on_screen && @mouse_drawn
      @screen.draw_crosshairs_at(mouse_screen_coords)
    end

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

  def mouse_on_screen
    msc = mouse_screen_coords
    return false if msc.x <= 0
    return false if msc.x > screen.width
    return false if msc.y <= 0
    return false if msc.y > screen.height
    true
  end

  def update_all
    @clock.tick
    @input_manager.clear_keys
    @input_manager.update_key_state

    #TODO hack delete me

    update_game_state
  end
  def simulate
    update_all
    draw
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


  def play_effect(name)
    @sound_manager.play_effect(name)
  end


  def enter_menu(name=@main_menu_name)
    @menu_manager.activate(name)
    @hud.menu_mode = true
  end

  def current_menu_index
    @menu_manager.current_menu_index
  end

  def temporary_message=(msg)
    @temporary_message = msg
  end

  def mouse_screen_coords
    [window.mouse_x, window.mouse_y ]
  end

  def mouse_world_coordinates
    msc = mouse_screen_coords
    @camera.world_coordinates_for(msc)
  end

  #TODO make wiki note that screen coords are top left to bottom right


  #TODO hack throwaway
  def hack_todo_print_mouse_location

    mx = window.mouse_x
    my = window.mouse_y
    puts "Got mouse location #{mx},#{my}  (they are: #{mx.class})"
  end
end
