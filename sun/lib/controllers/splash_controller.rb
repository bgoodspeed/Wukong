# To change this template, choose Tools | Templates
# and open the template in the editor.
class Splash
  attr_accessor :name, :position
  alias_method :image_file, :name
  def initialize(name)
    @name = name
    @position = [0,0]
  end
end
class SplashController
  attr_accessor :splash_mode, :splash
  def initialize(game)
    @game = game
    @splash_mode = false
  end

  def add_splash(splash)
    @game.image_controller.register_image(splash)
    @splash = Splash.new(splash)
  end

  def draw(screen)
    @game.image_controller.draw_image(@splash)
  end
end
