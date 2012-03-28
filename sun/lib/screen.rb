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
    #self.caption = "Wukong: green(0xff55b053) Filled Background"

    #TODO TNT working image background, should be pulled into level config
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

  def screenshotBG
    
    glEnable(GL_TEXTURE_2D)
    ss = screenshot
    glFlush()
    ss
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
  def button_down?(button)
    @window.button_down?(button)
  end
end
