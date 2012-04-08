# To change this template, choose Tools | Templates
# and open the template in the editor.

class Player
  include TransparencyUtils
  MAX_TURN_DEGREES = 360
  attr_reader :radius
  ATTRIBUTES = [:step_size, :position, :weapon, :direction, :health, :max_health, 
    :turn_speed, :movement_distance, :menu_action_delay, :enemies_killed
  ]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['player']
    obj = Player.new(conf['image_path'], game)
    obj.equip_weapon(YamlLoader.from_file(Weapon, game, conf['weapon_yaml'])) if conf['weapon_yaml']
    process_attributes(ATTRIBUTES, obj, conf)
    obj
  end

  attr_reader :image_file
  def initialize(avatar, game)
    @game = game
    #TODO move register image calls into loaders/yaml parsers
    @image_file = avatar
    @avatar = @game.image_manager.register_image(avatar)
    #@avatar.clear :dest_select => transparency_color
    p = [@avatar.width/2.0, @avatar.height/2.0 ]
    @radius = p.max
    @position = p
    @health = 0
    @direction = 0
    @enemies_killed = 0
    @step_size = 1
    @turn_speed = 90
    @menu_action_delay = 4
    @movement_distance = 1
    @radius = [@avatar.width/2.0, @avatar.height/2.0].max
    @last_distance = nil
    @weapon = nil
  end
  def inactivate_weapon
    @weapon.inactivate
  end
  def use_weapon
    #TODO could log this, emit a temp msg to the hud etc
    return unless @weapon
    @weapon.use
  end

  def tick_weapon
    @weapon.tick
  end
  def weapon_in_use?
    
    !@weapon.nil? and @weapon.in_use?
  end
  def equip_weapon(w)
    @weapon = w
    @weapon.equipped_on = self
    #TODO we don't want to actually load the animation from disk at this point
    @game.load_animation(self, "weapon", @weapon.image_path, 24, 24, false) #TODO hardcoded values
  end

  def turn(direction)
    @direction = ((@direction + direction) % MAX_TURN_DEGREES)
  end
  include GraphicsApi
  def move_forward(distance)
    dv = distance * @step_size
    mv = [calculate_offset_x(@direction, dv), calculate_offset_y(@direction, dv)]
    @position = @position.plus(mv)
    @last_distance = distance
  end

  def animation_position_by_name(name)
    raise "programmer error: unknown animation #{name}" unless name =~ /attack/ or name =~ /weapon/
    @game.camera.screen_coordinates_for(@position).dup
    #@position.dup
  end

  #TODO likely to be duplicated
  def undo_last_move
    unless @last_distance.nil?
      move_forward(-1 * @last_distance)
      @last_distance = nil
    end
  end

  def collision_response_type
    self.class
  end
  #TODO use strings/enums/symbols for collision types not classes, make these first class values
  def collision_type
    to_collision.class
  end

  def to_collision
    Primitives::Circle.new(@position, @radius)
  end
  def collision_radius
    to_collision.radius
  end
  def collision_center
    to_collision.position
  end

  def enemy_killed
    @enemies_killed += 1
  end
  #TODO this should be in a module
  def take_damage(col)
    #puts "#{self} took damage from #{col}"
    #TODO this doesn't really make sense but illustrates possible behaviors
    @health -= 1
  end
  
  def to_s
    "#{self.class} #{collision_type} r=#{collision_radius} c=#{collision_center}"
  end

end
