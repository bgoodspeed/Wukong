# To change this template, choose Tools | Templates
# and open the template in the editor.

class Player
  include TransparencyUtils
  MAX_TURN_DEGREES = 360
  attr_reader :direction, :radius
  attr_accessor :step_size, :position, :weapon
  def initialize(avatar, window)
    @avatar = Gosu::Image.new(window, avatar, false)
    @avatar.clear :dest_select => transparency_color
    @position = [@avatar.width/2.0, @avatar.height/2.0 ]
    @direction = 0
    @step_size = 1
    @radius = [@avatar.width/2.0, @avatar.height/2.0].max
    @last_distance = nil
    @weapon = nil
  end

  def use_weapon
    @weapon.use
  end

  def draw_weapon
    @weapon.draw
  end
  def tick_weapon
    @weapon.tick
  end
  def weapon_in_use?
    
    !@weapon.nil? and @weapon.in_use?
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

  def animation_position_by_name(name)
    raise "unknown animation #{name}" unless name =~ /attack/
    @position.dup
  end
  def undo_last_move
    unless @last_distance.nil?
      move_forward(-1 * @last_distance)
      @last_distance = nil
    end
  end

  def draw(screen)
    @avatar.draw_rot(@position[0] , @position[1] , ZOrder.dynamic.value, @direction)
  end
end
