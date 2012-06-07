 
#TODO reconsider this design
# Copyright 2012 Ben Goodspeed
class MouseCollisionWrapper
  attr_reader :position, :radius, :collision_priority
  def initialize(game, pos, r = 5)
    @game = game
    @position = pos
    @radius = r
    @collision_priority = CollisionPriority::MID
  end

  def collision_type
    to_collision.collision_type
  end

  def collision_response_type
    self.class.to_s
  end

  def to_collision
    Primitives::Circle.new(@position, @radius)
  end

  def collision_radius
    @radius
  end
  def collision_center
    @position
  end
end
