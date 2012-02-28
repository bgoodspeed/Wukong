# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'level'
require 'screen'
require 'player'
require 'enemy'

require 'loaders/player_loader'
require 'loaders/level_loader'

class Game
  def self.default_dependencies
    {
      :level_loader => LevelLoader.new,
      :player_loader => PlayerLoader.new,
    }
  end

  def initialize(deps = {})
    dependencies = Game.default_dependencies.merge(deps)
    @player_loader = dependencies[:player_loader]
    @level_loader = dependencies[:level_loader]
    @screen = Screen.new(dependencies[:width], dependencies[:height])
  end

  def load_level(level_name)
    @level = @level_loader.load_level(level_name)
    @player = @player_loader.load_player
    # @level.add_player(@player)
    @level
  end

  def set_screen_size(width, height)
    @screen.set_size(width, height)
  end

  def render_one_frame
    @level.draw(@screen)
    
  end

  def player_position
    @player.position
  end

  def capture_screenshot(name)
    @screen.capture_screenshot(name)
  end
end
