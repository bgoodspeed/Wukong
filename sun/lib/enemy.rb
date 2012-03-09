
class Enemy

  attr_accessor :position, :health

  def initialize(enemy_avatar, game)
    @game = game
    @enemy_avatar = Gosu::Image.new(@game.window, enemy_avatar, false)
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @health = 15
    @position = p
    @direction = 0
  end
  def undo_last_move
    unless @last_distance.nil?
      move_forward(-1 * @last_distance)
      @last_distance = nil
    end
  end

  #TODO clean this up
  include UtilityDrawing
  def draw(screen)
    @enemy_avatar.draw_rot(@position[0] , @position[1] , ZOrder.dynamic.value, @direction)
#    draw_line_segment(screen, Primitives::LineSegment.new(@position, @position.plus([@radius, 0])), ZOrder.dynamic.value)
#    draw_line_segment(screen, Primitives::LineSegment.new(@position, @position.plus([0, @radius])), ZOrder.dynamic.value)
#    draw_line_segment(screen, Primitives::LineSegment.new(@position, @position.plus([0, -@radius])), ZOrder.dynamic.value)
#    draw_line_segment(screen, Primitives::LineSegment.new(@position, @position.plus([-@radius,0])), ZOrder.dynamic.value)
  end

  def collision_type
    Enemy
  end
  def collision_radius
    @radius
  end
  def collision_center
    @position
  end

  def dead?
    @health <= 0
  end
  #TODO this should be in a module 
  def take_damage(from)
    # puts "#{self} took damage from #{from}"
    @health -= 1
    if dead?
      @game.add_death_event(self)
    end
  end
  def to_s
    "#{self.class} #{collision_type} r=#{collision_radius} c=#{collision_center}"
  end
end