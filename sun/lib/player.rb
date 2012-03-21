# To change this template, choose Tools | Templates
# and open the template in the editor.

class Player
  include TransparencyUtils
  MAX_TURN_DEGREES = 360
  attr_reader :radius
  attr_accessor :step_size, :position, :weapon, :direction, :health
  def initialize(avatar, game)
    @game = game
    @avatar = Gosu::Image.new(@game.window, avatar, false)
    #@avatar.clear :dest_select => transparency_color
    p = [@avatar.width/2.0, @avatar.height/2.0 ]
    @radius = p.max
    @position = p
    @health = 0
    @direction = 0
    @step_size = 1
    @radius = [@avatar.width/2.0, @avatar.height/2.0].max
    @last_distance = nil
    @weapon = nil
  end
  def inactivate_weapon
    @weapon.inactivate
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
  def equip_weapon(w)
    @weapon = w
    @game.load_animation(self, "weapon", @weapon.image_path, 24, 24, false) #TODO hardcoded values
  end

  def screen_coordinates(camera)
    @position.minus(camera.offset)
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
    raise "programmer error: unknown animation #{name}" unless name =~ /attack/ or name =~ /weapon/
    screen_coordinates(@game.camera).dup
    #@position.dup
  end

  #TODO likely to be duplicated
  def undo_last_move
    unless @last_distance.nil?
      move_forward(-1 * @last_distance)
      @last_distance = nil
    end
  end

  #TODO use strings/enums/symbols for collision types not classes
  def collision_type
    self.class
  end
  def collision_radius
    @radius
  end
  def collision_center
    @position
  end

  #TODO this should be in a module
  def take_damage(col)
    #puts "#{self} took damage from #{col}"
    #TODO this doesn't really make sense but illustrates possible behaviors
    @health -= 1
  end
  #TODO clean this up
  include UtilityDrawing
  def draw(screen)
    coords = screen_coordinates(@game.camera)
    @avatar.draw_rot(coords[0] , coords[1] , ZOrder.dynamic.value, @direction)
    

  end
  def to_s
    "#{self.class} #{collision_type} r=#{collision_radius} c=#{collision_center}"
  end

end
