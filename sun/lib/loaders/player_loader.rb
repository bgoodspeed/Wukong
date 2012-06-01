# To change this template, choose Tools | Templates
# and open the template in the editor.

class PlayerLoader
  def initialize(game)
    @game = game
  end

  def config
    {
      'image_path' => "game-data/sprites/avatar.bmp"
    }
  end

  def load_player
    conf = config
    avatar = @game.image_controller.register_image(conf['image_path'])
    p = GVector.xy(avatar.width/2.0, avatar.height/2.0)
    radius = p.min
    position = p
    conf['radius'] = p.max
    conf['start_position'] = p
    conf['collision_primitive'] = Primitives::Circle.new(position, radius)

    Player.new(@game, conf )
  end
end
