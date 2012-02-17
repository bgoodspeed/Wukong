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

  def draw
    puts "draw screen"
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
end
