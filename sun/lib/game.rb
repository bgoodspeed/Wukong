# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'statemachine'

require 'utility_vector_math'
class Array
  include ArrayVectorOperations
end

require 'zorder'
require 'utility_drawing'
require 'level'
require 'screen'
require 'player'
require 'clock'
require 'heads_up_display'
require 'collision_responder'
require 'way_finding'
require 'artificial_intelligence'
require 'animation_manager'



require 'loaders/player_loader'
require 'loaders/level_loader'



class Game

  attr_accessor :player, :clock, :hud, :animation_manager
  def initialize(deps = {})
    dependencies = {:framerate => 60}.merge(deps)
    @screen = Screen.new(self, dependencies[:width], dependencies[:height])
    @player_loader = PlayerLoader.new(self)
    @level_loader = LevelLoader.new
    @collision_responder = CollisionResponder.new(self)
    @animation_manager = AnimationManager.new(self)
    @keys = {}
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

  def set_screen_size(width, height)
    @screen.set_size(width, height)
  end

  def draw
    render_one_frame
  end

  @@UP = "Up"
  @@RIGHT = "Right"
  @@LEFT = "Left"
  @@DOWN = "Down"
  @@TURN_SPEED = 90 #TODO this is probably too fast
  @@MOVEMENT_DISTANCE = 1 #TODO this is probably too fast
  def update_game_state
    if @keys[@@RIGHT]
      @player.turn(@@TURN_SPEED)
    end
    if @keys[@@UP]
      @player.move_forward(@@MOVEMENT_DISTANCE)
    end

    @animation_manager.tick
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

  def simulate
    @clock.tick
    update_key_state
    update_game_state
    draw
    while @clock.current_frame_too_fast? do
      # TODO NOOP, could sleep to free up CPU cycles
    end
  end
end
