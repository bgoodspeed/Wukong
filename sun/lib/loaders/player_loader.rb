# To change this template, choose Tools | Templates
# and open the template in the editor.

class PlayerLoader
  def initialize(game)
    @game = game
  end

  def config
    {
      'avatar' => "game-data/sprites/avatar.png"
    }
  end

  def load_player
    Player.new(config['avatar'], @game)
  end
end
