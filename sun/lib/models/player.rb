# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'yaml'

class Player
  include TransparencyUtils
  MAX_TURN_DEGREES = 360
  attr_reader :radius
  ATTRIBUTES = [:step_size, :position, :weapon, :direction, :health, :max_health, 
    :turn_speed, :movement_distance, :menu_action_delay, :enemies_killed, :image_path, :collision_priority
  ]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include YamlHelper

  include MovementUndoable
  include Health
  include Collidable

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['player']
    obj = Player.new(conf['image_path'], game)
    if conf['weapon_yaml']
      w = YamlLoader.from_file(Weapon, game, conf['weapon_yaml'])
      w.orig_filename = conf['weapon_yaml']
      obj.equip_weapon(w)
    end
    process_attributes(ATTRIBUTES, obj, conf)
    obj
  end

  
  attr_reader :image_file
  def initialize(avatar, game)
    @game = game
    #TODO move register image calls into loaders/yaml parsers
    @image_file = avatar
    @avatar = @game.image_controller.register_image(avatar)
    #@avatar.clear :dest_select => transparency_color
    p = [@avatar.width/2.0, @avatar.height/2.0 ]
    @radius = p.max
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
    @collision_priority = CollisionPriority::MID
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
    #TODO we don't want to actually load the animation from disk at this point
    @game.load_animation(self, @weapon.animation_name, @weapon.image_path, 24, 24, false) #TODO hardcoded values

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
  end

  def turn(direction)
    @direction = ((@direction + direction) % MAX_TURN_DEGREES)
  end
  include GraphicsApi
  def move_forward(distance)
    dv = distance * @step_size
    mv = [calculate_offset_x(@direction, dv), calculate_offset_y(@direction, dv)]
    @position = @position.plus(mv)
    @last_move = mv
    @last_distance = distance
  end

  def animation_position_by_name(name)
    raise "programmer error: unknown animation #{name}" unless name =~ /attack/ or name =~ /weapon/
    #@game.camera.screen_coordinates_for(@position).dup
    @position.dup
  end

  def stop_weapon(arg=nil)
    @weapon.inactivate
  end


  def enemy_killed
    @enemies_killed += 1
  end

  
  def to_yaml
    overrides = {  }
    overrides[:weapon] = {:new_key => :weapon_yaml, :new_value => @weapon.orig_filename} if @weapon
    cf = attr_to_yaml(ATTRIBUTES, overrides)
    {"player" => cf}.to_yaml(:UseHeader => true)
  end
end
