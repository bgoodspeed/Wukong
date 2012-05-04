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
  NON_YAML_ATTRIBUTES = [:inventory, :avatar, :is_moving, :animation_name,
    :image_file, :animation_path, :animation_paths_by_name, :main_animation_name
  ]
  ATTRIBUTES = YAML_ATTRIBUTES + NON_YAML_ATTRIBUTES
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include YamlHelper

  include MovementUndoable
  include Health
  include Collidable

  def self.defaults
    {
      'animation_name' => 'main_player_anim',
      'animation_width' => 30,
      'animation_height' => 30,
      'animation_rate' => 10,
      'health' => 0,
      'direction' => 0,
      'step_size' => 1,
      'turn_speed' => 90,
      'menu_action_delay' => 4,
      'enemies_killed' => 0,
      'movement_distance' => 1,
      'base_accuracy' => 100
    }
  end

  attr_reader :player_animation

  def initialize(game, in_conf={})
    conf = self.class.defaults.merge(in_conf)
    @game = game
    #TODO move register image calls into loaders/yaml parsers
    @image_file = conf['image_path']
    @avatar = @game.image_controller.register_image(conf['image_path'])
    #@avatar.clear :dest_select => transparency_color
    p = [@avatar.width/2.0, @avatar.height/2.0 ]
    @radius = p.min
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
    @collision_priority = CollisionPriority::MID

    @main_animation_name = conf['animation_name']
    @animation_name = conf['animation_name']
    @animation_path = conf.has_key?('animation_path') ? conf['animation_path'] : avatar #TODO hackity hack
    @animation_paths_by_name = {
      @animation_name.to_s => @animation_path
    }
    @player_animation = @game.animation_controller.register_animation(self, @animation_name,
        @animation_path, conf['animation_width'], conf['animation_height'], false,
        false, conf['animation_rate'])

    @health = conf['health']
    @direction = conf['direction']
    @enemies_killed = conf['enemies_killed']
    @step_size = conf['step_size']
    @turn_speed = conf['turn_speed']
    @menu_action_delay = conf['menu_action_delay']
    @movement_distance = conf['movement_distance']
    @base_accuracy = conf['base_accuracy']

    @is_moving = false

    @radius = [@avatar.width/2.0, @avatar.height/2.0].max
    @last_distance = nil
    @inventory = conf.has_key?('inventory') ? conf['inventory'] : Inventory.new(game, self)
  end
  def inactivate_weapon
    @inventory.weapon.inactivate
  end
  def use_weapon
    @game.log.debug { "Tried to use weapon" }
    #TODO could log this, emit a temp msg to the hud etc
    return unless @inventory.weapon
    @game.animation_controller.play_animation(self, @inventory.weapon.animation_name) #TODO hardcoded values
    @game.log.debug { "Used weapon" }
    @inventory.weapon.use
  end

  def animation_path_for(name)
    @animation_paths_by_name[name]
  end

  def weapon_in_use?
    !@inventory.weapon.nil? and @inventory.weapon.in_use?
  end
  def equip_weapon(w)
    @inventory.weapon = w
    @inventory.weapon.equipped_on = self
    @animation_paths_by_name[@inventory.weapon.animation_name] = @inventory.weapon.image_path
    @game.animation_controller.register_animation(self, @inventory.weapon.animation_name, @inventory.weapon.image_path, 24, 24, false) #TODO hardcoded values
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
    #@game.camera.screen_coordinates_for(@position).dup
    @position.dup
  end

  def stop_weapon(arg=nil)
    #TODO should player control this animation stuff? or weapon? probably weapon
    @game.animation_controller.stop_animation(self, @inventory.weapon.animation_name)
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
