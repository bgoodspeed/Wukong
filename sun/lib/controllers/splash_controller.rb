# To change this template, choose Tools | Templates
# and open the template in the editor.# Copyright 2012 Ben Goodspeed
class Splash
  attr_accessor :name, :position
  alias_method :image_file, :name
  def initialize(name)
    @name = name
    @position = [0,0]
  end
end# Copyright 2012 Ben Goodspeed
class SplashController
  attr_accessor :splash_mode, :splash, :splashes, :splash_rate, :splash_fade
  def initialize(game)
    @game = game
    @splash_mode = false
    @splashes = []
    @splash_index = 0
    @splash_rate = 60
    @splash_fade = 20
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

  include UtilityDrawing
  def draw(screen)
    @ticks += 1
    if @ticks > @splash_rate
      @ticks = 0
      @splash_index = (@splash_index + 1) % @splashes.size
    end

    @game.image_controller.draw_image(current_splash)
    if @ticks < @splash_fade
      darken_screen(@game, 0, @game.screen.width, 0, @game.screen.width, fade_in_color_for((@splash_fade - @ticks).to_f/@splash_fade.to_f, 0,0,0))
    end

  end
end
