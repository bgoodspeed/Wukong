# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'yaml'
# Copyright 2012 Ben Goodspeed
class Player
  include TransparencyUtils
  MAX_TURN_DEGREES = 360


  YAML_ATTRIBUTES = [:step_size, :position, :direction, :turn_speed, :movement_distance, :menu_action_delay,
    :enemies_killed, :image_path, :collision_priority, :base_accuracy,   :animation_width, :animation_height,
    :image_file, :animation_path,  :main_animation_name, :animation_name, :footsteps_effect_name, :damage_sound_effect_name,
    :max_energy_points, :energy_points, :radius

  ]
  NON_YAML_ATTRIBUTES = [:inventory, :avatar, :is_moving, :animation_name,:animation_paths_by_name,  :last_damage]

  ATTRIBUTES = YAML_ATTRIBUTES + NON_YAML_ATTRIBUTES
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include YamlHelper
  include ValidationHelper

  include MovementUndoable
  include Health
  include Collidable

  def self.defaults
    {
       'footsteps_effect_name' => "footsteps",
      'animation_name' => 'main_player_anim',
      'animation_width' => 30,
      'animation_height' => 30,
      'animation_rate' => 10,
      'direction' => 0,
      'step_size' => 1,
      'turn_speed' => 90,
      'menu_action_delay' => 4,
      'enemies_killed' => 0,
      'movement_distance' => 1,
      'energy_points' => 0,
      'max_energy_points' => 1000,
      'base_accuracy' => 100,
      'collision_priority' => CollisionPriority::MID,
      'stats' => {
          'health' => 10,
          'max_health' => 15,
      },
      'progression' => {
          'upgrade_points' => 0
      }

    }
  end

  attr_reader :player_animation, :stats, :required_attributes, :progression

  def initialize(game, in_conf={})
    conf = self.class.defaults.merge(in_conf)
    @game = game
    #TODO move register image calls into loaders/yaml parsers
    @position = conf['start_position']
    @collision_type = conf['collision_primitive']
    @main_animation_name = conf['animation_name']
    @animation_path = conf.has_key?('animation_path') ? conf['animation_path'] : conf['image_path'] #TODO hackity hack
    @animation_paths_by_name = {
      @animation_name.to_s => @animation_path
    }
    @player_animation = @game.animation_controller.register_animation(self, conf['animation_name'], @animation_path,
                             conf['animation_width'], conf['animation_height'], false,false, conf['animation_rate'])

    self.is_moving=(false)

    @last_distance = nil
    scf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(scf)
    pcf = conf['progression'] ? conf['progression'] : {}
    @progression = Progression.new(pcf)
    @inventory = conf.has_key?('inventory') ? conf['inventory'] : Inventory.new(game, self)
    process_attributes(YAML_ATTRIBUTES, self, conf, {:position => Finalizers::GVectorFinalizer.new} )
    @required_attributes = (YAML_ATTRIBUTES - [:animation_path, :damage_sound_effect_name, :image_path, :image_file]) + [:inventory, :radius, :animation_name]
  end

  def upgrade_points
    @progression.upgrade_points
  end

  def add_upgrade_points(n)
    @progression.upgrade_points += n
  end

  def tick
    @energy_points += 1
    @energy_points = [@energy_points, @max_energy_points].min
  end

  def effective_stats
    @stats.plus_stats(@inventory.equipped_stats)
  end

  def health=(v)
    @stats.health = v
  end

  def health
    @stats.health
  end
  def max_health
    @stats.max_health
  end


  def is_moving=(v)
    if v
      @game.animation_controller.play_animation(self, @main_animation_name)
    else
      @game.animation_controller.stop_animation(self, @main_animation_name)
    end
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
  def equip_armor(a)
    @inventory.armor = a
    @inventory.armor.equipped_on = self
    #@animation_paths_by_name[@inventory.weapon.animation_name] = @inventory.weapon.image_path
    #@game.animation_controller.register_animation(self, @inventory.weapon.animation_name, @inventory.weapon.image_path, 24, 24, false) #TODO hardcoded values
  end

  #TODO need to add in weapon accuracy
  def effective_accuracy
    accuracy + @stats.accuracy
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
    mv = GVector.xy(calculate_offset_x(@direction, dv), calculate_offset_y(@direction, dv))
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @position.plus(tmp, mv)
    @position = tmp
    @last_move = mv
    @last_distance = distance
  end

  def last_move
    @last_move
  end

  def animation_position_by_name(name)
    #@game.camera.screen_coordinates_for(@position).dup
    GVector.xy(@position.x, @position.y)
  end

  def stop_weapon(arg=nil)
    #TODO should player control this animation stuff? or weapon? probably weapon
    @game.animation_controller.stop_animation(self, @inventory.weapon.animation_name)
    @inventory.weapon.inactivate
  end

  def acquire_inventory(inventory)
    @inventory.add_all(inventory)
  end

  def use_item(item)
    s = item.stats
    @stats = @stats.plus_stats_clamped(s)
    @inventory.remove_item(item)

  end
  def take_reward(item)
    @inventory.add_item(item)
  end

  def enemy_killed(enemy)
    v = enemy.upgrade_point_value
    add_upgrade_points(v)
    @enemies_killed += 1
  end

  
  def to_yaml
    cf = attr_to_yaml(YAML_ATTRIBUTES)
    cf['stats'] = @stats.to_yaml
    cf['position'] = @position.to_yaml
    cf['progression'] = @progression.to_yaml
    {"player" => cf}.to_yaml(:UseHeader => true)
  end
end
