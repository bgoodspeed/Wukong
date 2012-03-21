# To change this template, choose Tools | Templates
# and open the template in the editor.

class Camera
  def initialize(game)
    @game = game
  end

  def screen_width
    @game.screen.width
  end
  def screen_height
    @game.screen.height
  end

  def offset
    position.minus([screen_width/2.0, screen_height/2.0])
  end

  def position
    @game.player.position
  end
end
