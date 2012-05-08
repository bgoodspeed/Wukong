
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :health, :velocity, :name, :collision_priority,
                :image_file, :direction, :animation_name, :animation_path
  ]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include MovementUndoable
  include Health
  include Collidable
  include YamlHelper

  def self.defaults
    {
      'animation_name' => "enemy_animation",
      'animation_width' => 50,
      'animation_height' => 50,
      'animation_rate' => 10,
      'health' => 15,
      'velocity' => 5,
      'direction' => 0.0,
      'collision_priority' => CollisionPriority::LOW
    }
  end
  def initialize( game, conf_in)
    conf = self.class.defaults.merge(conf_in)
    @game = game
    @image_file = conf['image_path']
    #TODO move image registration out of constructor into loader
    @animation_path = conf.has_key?('animation_path') ? conf['animation_path'] : conf['image_path']
    @enemy_animation = @game.animation_controller.register_animation(self, conf['animation_name'],
      @animation_path, conf['animation_width'], conf['animation_height'], false, false, conf['animation_rate'])
    @enemy_avatar = @game.image_controller.register_image(conf['image_path'])
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
    process_attributes(ATTRIBUTES, self, conf)
  end
  def animation_path_for(name)
    @animation_path
  end
  #TODO hackish
  def hud_message
    "Enemy : #{@health}HP"
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
    (Math::atan(vector[1].to_f/vector[0].to_f) * 180.0)/Math::PI
  end
  def tick_tracking(vector)
    @last_move = vector.scale(@velocity)
    @direction = angle_for(vector)
    @position = @position.plus(@last_move)
  end

  def animation_position_by_name(name)
    @position.dup
  end

end