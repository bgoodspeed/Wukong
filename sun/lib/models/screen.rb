# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'opengl'
require 'glu'
include Gl
include Glu

require 'gosu'
#require 'devil/gosu'
class GameWindow < Graphics::Window
  def width; @w; end
  def height; @h; end

  def initialize(game, width, height, fr=33.3333333)
    super width, height, false, fr
    @w = width
    @h = height
    @game = game
    #TODO extract this stuff to config file
    self.caption = "Haligonia: Demo"
  end

  def update
    @game.update_all
  end

  def draw
    @game.draw
  end
end



class Screen
  def initialize(game, width, height)
    @game = game
    @window = GameWindow.new(game, width, height)

  end
  def width; @window.width; end
  def height; @window.height; end

  def draw
    @window.draw
  end

  def close
    @window.close
  end

  def show
    @window.show
  end
  def window
    @window
  end
  
  def draw_quad(*args)
    @window.draw_quad(*args)
  end
  def draw_line(*args)
    @window.draw_line(*args)
  end
  def draw_crosshairs_at(p, l=4)
    @window.draw_line(p.x - l, p.y, Graphics::Color::WHITE, p.x + l, p.y, Graphics::Color::WHITE, ZOrder.hud.value)
    @window.draw_line(p.x, p.y - l, Graphics::Color::WHITE, p.x, p.y + l, Graphics::Color::WHITE, ZOrder.hud.value)
  end

  def button_down?(button)
    @window.button_down?(button)
  end
end
