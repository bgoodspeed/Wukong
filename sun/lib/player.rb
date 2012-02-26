# To change this template, choose Tools | Templates
# and open the template in the editor.

class Player
  MAX_TURN_DEGREES = 360
  attr_reader :position, :direction
  attr_accessor :step_size
  def initialize(avatar, window)
    @avatar = Gosu::Image.new(window, avatar, false)
    @avatar.clear :dest_select => transparency_color
    @position = [0,0]
    @direction = 0
    @step_size = 1
  end

  def transparency_color
    Gosu::Color.argb(0xffff00ff)
  end

  def turn(direction)
    @direction = ((@direction + direction) % MAX_TURN_DEGREES)
  end

  def move_forward(distance)
    mv = []
    mv[0] = Gosu::offset_x(@direction, distance * @step_size)
    mv[1] = Gosu::offset_y(@direction, distance * @step_size)
    #move = mv.collect {|m| m * distance}
    @position[0] = @position[0] + mv[0]
    @position[1] = @position[1] + mv[1]
    
  end
  def draw(screen)
    @avatar.draw(@position[0], @position[1], 1)
  end
end
