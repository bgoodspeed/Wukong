
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :velocity, :name, :collision_priority, :base_direction,
                :image_file, :direction, :animation_name, :animation_path, :damage_sound_effect_name
  ]
  NON_YAML_ATTRIBUTES = [:stats]
  (ATTRIBUTES + NON_YAML_ATTRIBUTES).each {|attr| attr_accessor attr }

  extend YamlHelper
  include MovementUndoable
  include Health
  include Collidable
  include YamlHelper

  def self.defaults
    {
      'animation_name' => "enemy_animation",
      'damage_sound_effect_name' => 'enemy_damage_effect',
      'animation_width' => 50,
      'animation_height' => 50,
      'animation_rate' => 10,
      'velocity' => 5,
      'direction' => 0.0,
      'base_direction' => 0.0,
      'collision_priority' => CollisionPriority::LOW,
      'stats' => {
          'health' => 15,
          'max_health' => 15,
      }

    }
  end
  attr_reader :radius
  def initialize(game, conf_in)
    conf = self.class.defaults.merge(conf_in)
    @game = game
    @image_file = conf['image_path']
    #TODO move image registration out of constructor into loader
    @animation_path = conf.has_key?('animation_path') ? conf['animation_path'] : conf['image_path']
    raise "bad anim name: #{conf['animation_name']}" unless conf['animation_name']
    @enemy_animation = @game.animation_controller.register_animation(self, conf['animation_name'],
      @animation_path, conf['animation_width'], conf['animation_height'], false, false, conf['animation_rate'])
    @enemy_avatar = @game.image_controller.register_image(conf['image_path'])
    if conf.has_key?('animation_width')
      p = [conf['animation_width']/2.0, conf['animation_height']/2.0 ]

    else
      p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    end


    @radius = p.max
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
    cf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(cf)
    @game.animation_controller.animation_index_by_entity_and_name(self, conf['animation_name']).needs_update = true
    process_attributes(ATTRIBUTES, self, conf)
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



  def animation_path_for(name)
    @animation_path
  end
  #TODO hackish
  def hud_message
    "Enemy : #{health}HP"
  end

  def angle_for(vector)
    if vector[0] == 0.0
      return 0.0 if vector[1] > 0
      return 180.0
    end
    if vector[1] == 0.0
      return 90.0 if vector[0] > 0
      return 270.0
    end

    rv = (Math::atan(vector[1].to_f/vector[0].to_f) * 180.0)/Math::PI
    if vector[0] < 0
      rv -= 180
    end
    rv
  end
  def tick_tracking(vector)
    @game.animation_controller.animation_index_by_entity_and_name(self, animation_name).needs_update = true
    @last_move = vector.scale(@velocity)
    @direction = (@base_direction + angle_for(vector)) % 360.0
    @position = @position.plus(@last_move)
  end

  def animation_position_by_name(name)
    @position.dup
  end

end