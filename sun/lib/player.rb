# To change this template, choose Tools | Templates
# and open the template in the editor.

class Player
  MAX_TURN_DEGREES = 360
  attr_reader :position, :direction, :radius
  attr_accessor :step_size
  def initialize(avatar, window)
    @avatar = Gosu::Image.new(window, avatar, false)
    @avatar.clear :dest_select => transparency_color
    @position = [@avatar.width/2.0, @avatar.height/2.0]
    @direction = 0
    @step_size = 1
    @radius = [@avatar.width/2.0, @avatar.height/2.0].max
    @last_distance = nil
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
    @position = @position.plus(mv)
    @last_distance = distance
  end

  def undo_last_move
    unless @last_distance.nil?
      move_forward(-1 * @last_distance)
      @last_distance = nil
    end
  end

  def draw(screen)
    @avatar.draw(@position[0] - @avatar.width/2.0, @position[1] - @avatar.height/2.0, 1)
  end
end
