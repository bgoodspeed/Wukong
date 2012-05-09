# To change this template, choose Tools | Templates
# and open the template in the editor.

class VectorFollower
  attr_reader :vector, :velocity, :collision_priority, :current_step
  def initialize(start, vector, velocity, owner)
    @owner = owner
    @start = start
    @vector = vector
    @velocity = velocity
    @current_step = 0
    #TODO this should be in a behavior module
    @collision_priority = CollisionPriority::HIGH
  end


  def velocity_scaled_vector
    @vector.scale(@velocity)
  end

  def tick
    @current_step += 1
  end
  def current_position
    @start.plus(@vector.scale(@current_step * @velocity))
  end

  #TODO this should be in a collidable module
  def to_collision
    Primitives::LineSegment.new(current_position, current_position.plus(velocity_scaled_vector)  )
  end

  def collision_type
    to_collision.class
  end
  def collision_radius
    @velocity
  end
  def collision_center
    current_position
  end
  def collision_response_type
    self.class
  end


  def to_s
    "#{self.class}: #{object_id} current position: #{current_position}; velocity #{@velocity}; vector #{@vector}"
  end
end
