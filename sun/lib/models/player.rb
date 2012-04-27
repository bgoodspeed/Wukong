# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'yaml'

class Player
  include TransparencyUtils
  MAX_TURN_DEGREES = 360
  attr_reader :radius
  YAML_ATTRIBUTES = [:step_size, :position, :direction, :health, 
    :max_health, :turn_speed, :movement_distance, :menu_action_delay,
    :enemies_killed, :image_path, :collision_priority, :base_accuracy
  ]
  ATTRIBUTES = YAML_ATTRIBUTES + [:inventory, :avatar]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include YamlHelper

  include MovementUndoable
  include Health
  include Collidable


  
  attr_accessor :image_file
  def initialize(avatar, game, inventory=nil)
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
    @base_accuracy = 100
    @radius = [@avatar.width/2.0, @avatar.height/2.0].max
    @last_distance = nil
    @inventory = inventory ? inventory : Inventory.new(game, self)
  end
  def inactivate_weapon
    @inventory.weapon.inactivate
  end
  def use_weapon
    @game.log.debug { "Tried to use weapon" }
    #TODO could log this, emit a temp msg to the hud etc
    return unless @inventory.weapon
    #TODO we don't want to actually load the animation from disk at this point
    @game.load_animation(self, @inventory.weapon.animation_name, @inventory.weapon.image_path, 24, 24, false) #TODO hardcoded values
    @game.log.debug { "Used weapon" }
    @inventory.weapon.use
  end


  def weapon_in_use?
    !@inventory.weapon.nil? and @inventory.weapon.in_use?
  end
  def equip_weapon(w)
    @inventory.weapon = w
    @inventory.weapon.equipped_on = self
  end

  #TODO need to add in weapon accuracy
  def accuracy
    @base_accuracy  
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
    @inventory.weapon.inactivate
  end


  def take_reward(item)
    @inventory.add_item(item)
  end

  def enemy_killed
    @enemies_killed += 1
  end

  
  def to_yaml
    cf = attr_to_yaml(YAML_ATTRIBUTES)
    {"player" => cf}.to_yaml(:UseHeader => true)
  end
end
