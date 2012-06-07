# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class VectorFollower
  attr_reader :vector, :velocity, :collision_priority, :current_step, :owner
  def initialize(start, vector, velocity, owner)
    @owner = owner
    @start = start
    @vector = vector
    @velocity = velocity
    @current_step = 0
    #TODO this should be in a behavior module
    @collision_priority = CollisionPriority::HIGH
  end

  def effective_stats
    @owner.effective_stats
  end
  def stats
    @owner.stats #TODO this might be too much, maybe just weapon stats?
  end
  def velocity_scaled_vector
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @vector.scale(tmp, @velocity)
    tmp
  end

  def tick
    @current_step += 1
  end
  def updated_vector
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @vector.scale(tmp, @current_step * @velocity)
    tmp
  end
  def current_position
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @start.plus(tmp, updated_vector)
    tmp
  end
  def distance_from_start
    @start.distance_from(current_position)
  end

  #TODO this should be in a collidable module
  def to_collision
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    tmp_min = GVector.xy(0,0) #NOTE temporary vector allocation
    current_position.minus(tmp_min, velocity_scaled_vector)
    current_position.plus(tmp, velocity_scaled_vector)
    Primitives::LineSegment.new(tmp_min,tmp )
  end

  def collision_type
    to_collision.collision_type
  end
  def collision_radius
    @velocity
  end
  def collision_center
    current_position
  end
  def collision_response_type
    self.class.to_s
  end


  def to_s
    "#{self.class}: #{object_id} current position: #{current_position}; velocity #{@velocity}; vector #{@vector}"
  end
end
