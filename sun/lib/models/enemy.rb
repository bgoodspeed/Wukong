# Copyright 2012 Ben Goodspeed
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :name, :collision_priority, :base_direction, :radius, :enemy_avatar,
                :image_file, :direction, :animation_name, :animation_path, :damage_sound_effect_name, :upgrade_point_value
  ]
  NON_YAML_ATTRIBUTES = [:stats, :artificial_intelligence, :attack_range, :inventory, :last_damage, :line_of_sight, :age]
  (ATTRIBUTES + NON_YAML_ATTRIBUTES).each {|attr| attr_accessor attr }

  extend YamlHelper
  include MovementUndoable
  include Health
  include Collidable
  include YamlHelper
  include ValidationHelper

  def self.defaults
    {
      'name' => 'DefaultEnemyName',
      'animation_name' => "enemy_animation",
      'damage_sound_effect_name' => 'enemy_damage_effect',
      'animation_width' => 50,
      'animation_height' => 50,
      'animation_rate' => 10,
      'position' => [ 25, 25 ],
      'radius' => 10,
      'upgrade_point_value' => 1,
      'direction' => 0.0,
      'base_direction' => 0.0,
      'collision_priority' => CollisionPriority::LOW,
      'stats' => {
          'health' => 15,
          'max_health' => 15,
          'speed' => 5,
      }

    }
  end
  attr_reader :required_attributes
  def initialize(game, conf_in)
    conf = self.class.defaults.merge(conf_in)
    @game = game
    @image_file = conf['image_path']
    #TODO move image registration out of constructor into loader
    @animation_path = conf.has_key?('animation_path') ? conf['animation_path'] : conf['image_path']
    raise "bad anim name: #{conf['animation_name']}" unless conf['animation_name']
    @enemy_animation = @game.animation_controller.register_animation(self, conf['animation_name'],
      @animation_path, conf['animation_width'], conf['animation_height'], false, false, conf['animation_rate'])
    @enemy_avatar = conf['enemy_avatar']

    @inventory = conf.has_key?('inventory') ? conf['inventory'] : Inventory.new(game, self)
    #TODO this should be a weapon property
    @attack_range = 4
    @line_of_sight = true
    @position = conf['start_position']
    @collision_type = conf['collision_primitive']
    @age = 0

    cf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(cf)
    if conf['artificial_intelligence']
      @artificial_intelligence = ArtificialIntelligenceLoader.from_conf(conf['artificial_intelligence'])
    else
      @artificial_intelligence = ArtificialIntelligence.default
    end
    @game.animation_controller.animation_index_by_entity_and_name(self, conf['animation_name']).needs_update = true
    process_attributes(ATTRIBUTES, self, conf, {:position => Finalizers::GVectorFinalizer.new})
    @required_attributes = ATTRIBUTES - [:image_file, :animation_path, :enemy_avatar]

  end
  def equip_weapon(w)
    @inventory.weapon = w
    @inventory.weapon.equipped_on = self
  end

  def inventory_empty?
    return true unless @inventory

    @inventory.items.empty?
  end

  def health=(v)
    @stats.health = v
  end

  def health
    @stats.health
  end
  def effective_stats
    #TODO when enemies have equipment make this do what player does
    @stats
  end

  def trigger_event(e)
    @artificial_intelligence.trigger_event(e)
  end


  def animation_path_for(name)
    @animation_path
  end
  #TODO hackish
  def hud_message
    "Enemy : #{health}HP"
  end

  def angle_for(vector)
    if vector.x == 0.0
      return 0.0 if vector.y > 0
      return 180.0
    end
    if vector.y == 0.0
      return 90.0 if vector.x > 0
      return 270.0
    end

    rv = (Math::atan(vector.y.to_f/vector.x.to_f) * 180.0)/Math::PI
    if vector.x < 0
      rv -= 180
    end
    rv
  end

  def velocity=(v)
    @stats.speed = v
  end

  def in_wait_state?
    @artificial_intelligence.current_state.to_s =~ /wait/
  end
  def in_chase_state?
    @artificial_intelligence.current_state.to_s =~ /chase/
  end
  def in_attack_state?
    @artificial_intelligence.current_state.to_s =~ /attack/
  end

  def weapon_ready?
    @inventory and @inventory.weapon
  end

  def time_since_last_shot_sufficient?
    return true if @last_shot_time.nil?
    (@game.clock.frames_rendered - @last_shot_time) > 30 #TODO hardcoded, should be in yaml
  end


  def try_attack
    return unless weapon_ready?
    if time_since_last_shot_sufficient?
      @inventory.weapon.use
      @last_shot_time = @game.clock.frames_rendered
    end

  end

  def inactivate_weapon
    @inventory.weapon.inactivate
  end
  def tick_tracking(vector)
    @direction = (@base_direction + angle_for(vector)) % 360.0
    return if in_wait_state?
    return try_attack if in_attack_state?


    @game.animation_controller.animation_index_by_entity_and_name(self, animation_name).needs_update = true
    tmp_s = GVector.xy(0,0) #NOTE temporary vector allocation
    vector.scale(tmp_s, @stats.speed)
    @last_move = tmp_s
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @position.plus(tmp, @last_move)
    @position = tmp
  end

  def animation_position_by_name(name)
    GVector.xy(@position.x, @position.y)
  end

end