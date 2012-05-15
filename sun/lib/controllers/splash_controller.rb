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
  attr_accessor :splash_mode, :splash, :splashes, :splash_rate
  def initialize(game)
    @game = game
    @splash_mode = false
    @splashes = []
    @splash_index = 0
    @splash_rate = 60
    @ticks = 0
  end

  def current_splash_index
    @splash_index
  end
  def add_splash(splash)
    @game.image_controller.register_image(splash)
    @splash = Splash.new(splash)
    @splashes << @splash
  end
  def current_splash
    @splashes[@splash_index]
  end

  def draw(screen)
    @ticks += 1
    if @ticks > @splash_rate
      @ticks = 0
      @splash_index = (@splash_index + 1) % @splashes.size
    end
    @game.image_controller.draw_image(current_splash)
  end
end
