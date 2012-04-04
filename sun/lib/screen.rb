# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'opengl'
require 'glu'
include Gl
include Glu

require 'gosu'
require 'devil/gosu'
class GameWindow < Gosu::Window
  def width; @w; end
  def height; @h; end

  def initialize(game, width, height)
    super width, height, false
    @w = width
    @h = height
    @game = game
    #TODO extract this stuff to config file
    self.caption = "Wukong: purplemonkeydishwasherbubblegum"
  end

  def update
    @game.update_all
  end

  def custom_green
    Gosu::Color.argb(0xff55b053)
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

  def capture_screenshot(name)
    File.delete(name) if File.exists?(name)
    @window.screenshot.save(name)
    #@window.screenshotBG.save(name)
  end

  def show
    @window.show
  end
  def window
    @window
  end
  def flush
    @window.flush
  end
  def draw_quad(*args)
    @window.draw_quad(*args)
  end
  def draw_line(*args)
    @window.draw_line(*args)
  end
  def draw_crosshairs_at(p, l=4)
    @window.draw_line(p.x - l, p.y, Gosu::Color::WHITE, p.x + l, p.y, Gosu::Color::WHITE, ZOrder.hud.value)
    @window.draw_line(p.x, p.y - l, Gosu::Color::WHITE, p.x, p.y + l, Gosu::Color::WHITE, ZOrder.hud.value)
  end

  def button_down?(button)
    @window.button_down?(button)
  end
end
