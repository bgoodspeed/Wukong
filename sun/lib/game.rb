# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'level'
require 'screen'
require 'player'

require 'loaders/player_loader'
require 'loaders/level_loader'

class Game

  attr_accessor :player
  def initialize(deps = {})
    dependencies = deps
    @screen = Screen.new(self, dependencies[:width], dependencies[:height])
    @player_loader = PlayerLoader.new(self)
    @level_loader = LevelLoader.new
    
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
  def render_one_frame
    
    @level.draw(@screen)
    
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
end
