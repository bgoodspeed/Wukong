# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'gosu'
require 'devil/gosu'
class GameWindow < Gosu::Window
  def initialize(game, width, height)
    super width, height, false
    @game = game
  end

  def update
    puts ("update screen/window")
  end

  def custom_green
    Gosu::Color.argb(0xff55b053)
  end
  
  def draw
    draw_quad(0, 0, custom_green, 0, 480, custom_green, 640, 480, custom_green, 640, 0, custom_green, 0)
    @game.draw
    
  end

end



class Screen
  def initialize(game, width, height)
    @game = game
    @window = GameWindow.new(game, width, height)

  end


  def draw
    @window.draw
  end
  def capture_screenshot(name)
    @window.screenshot.save(name)
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
  def draw_line(*args)
    @window.draw_line(*args)
  end
  def button_down?(button)
    @window.button_down?(button)
  end
end
