# To change this template, choose Tools | Templates
# and open the template in the editor.

class Player
  attr_reader :position
  def initialize(avatar, window)
    @avatar = Gosu::Image.new(window, avatar, false)
    @avatar.clear :dest_select => transparency_color
    @position = [0,0]
  end

  def transparency_color
    Gosu::Color.argb(0xffff00ff)
  end

  def draw(screen)
    @avatar.draw(@position[0], @position[1], 1)
  end
end
