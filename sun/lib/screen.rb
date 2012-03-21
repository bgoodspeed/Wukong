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
    self.caption = "Wukong: green(0xff55b053) Filled Background"

    #TODO TNT working image background, should be pulled into level config
    self.caption = "Wukong: grass.jpg"
    @background_image = Gosu::Image.new(self, "game-data/background/grass.jpg", false)
  end

  def update
    @game.update_all
  end

  def custom_green
    Gosu::Color.argb(0xff55b053)
  end
  
  def draw
    #draw_quad(0, 0, custom_green, 0, 480, custom_green, 640, 480, custom_green, 640, 0, custom_green, 0)
    coords = [0,0].minus(@game.camera.offset)
    @background_image.draw(coords[0],coords[1],ZOrder.background.value)
   
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
