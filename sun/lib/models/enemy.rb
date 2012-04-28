
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :health, :velocity, :name, :collision_priority]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include MovementUndoable
  include Health
  include Collidable



  attr_reader :image_file, :direction
  def initialize(enemy_avatar, game)
    @game = game
    @image_file = enemy_avatar
    #TODO move image registration out of constructor into loader
    @enemy_avatar = @game.image_controller.register_image(enemy_avatar)
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @health = 15
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
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


end