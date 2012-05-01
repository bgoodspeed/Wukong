
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :health, :velocity, :name, :collision_priority]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include MovementUndoable
  include Health
  include Collidable



  attr_reader :image_file, :direction, :animated, :animation_name
  def initialize( game, conf)
    @game = game
    enemy_avatar = conf['image_path']
    @image_file = enemy_avatar
    @animation_name = "enemy_animation"
    #TODO move image registration out of constructor into loader
    if conf.has_key?('animation_width')
      @enemy_avatar = @game.animation_controller.register_animation(self, @animation_name,
        enemy_avatar, conf['animation_width'], conf['animation_width'], false,
        false, conf['animation_rate'])
      @animated = true
    else
      @enemy_avatar = @game.image_controller.register_image(enemy_avatar)
      @animated = false
    end
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
    
    @health = 15
    @velocity = 5
    @direction = 0.0
    @collision_priority = CollisionPriority::LOW
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