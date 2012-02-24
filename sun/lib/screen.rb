# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'gosu'
require 'devil/gosu'
class GameWindow < Gosu::Window
  def initialize(width, height)
    super width, height, false
  end

  def update
    puts ("update screen/window")
  end

  def custom_green
    Gosu::Color.argb(0xff55b053)
  end
  
  def draw
    draw_quad(0, 0, custom_green, 0, 480, custom_green, 640, 480, custom_green, 640, 0, custom_green)
  end

end



class Screen
  def initialize(width, height)

    @window = GameWindow.new(width, height)

  end

  def capture_screenshot(name)
    @window.draw
    
    @window.screenshot.save(name)
  end

  def show
    @window.show
  end
end
