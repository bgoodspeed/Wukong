# To change this template, choose Tools | Templates
# and open the template in the editor.

class VectorFollower
  attr_reader :vector, :velocity
  def initialize(start, vector, velocity)
    @start = start
    @vector = vector
    @velocity = velocity
    @current_step = 0
  end


  def velocity_scaled_vector
    @vector.scale(@velocity)
  end
  def scaled_vector
    @vector.scale(@current_step * @velocity)
  end

  def tick
    @current_step += 1
  end
  def current_position
    @start.plus(@vector.scale(@current_step * @velocity))
  end
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

class PathFollowingManager
  attr_reader :vector_following, :tracking
  def initialize(game)
    @game = game
    @vector_following = []
    @tracking = {}
  end

  def tick
    @vector_following.each {|vf| vf.tick}
    @tracking.each {|h, wf| h.tick_tracking(current_tracking_direction_for(h))}
  end
  def remove_projectile(p)
    @vector_following -= [p]
  end
  def add_projectile(start, theta, velocity)
    vector = start
    vector = []
    vector[0] = Gosu::offset_x(theta, 1) #TODO isolate all gosu references
    vector[1] = Gosu::offset_y(theta, 1)
    vf = VectorFollower.new(start, vector, velocity)
    @vector_following << vf
    vf
  end

  def tracking_point_for(hunter)
    target = hunter.tracking_target.position
    tp = @tracking[hunter].best_point(hunter.position, target)
    tp.nil? ? target : tp
  end

  def current_tracking_direction_for(hunter)
    pt = tracking_point_for(hunter)
    pt.minus(hunter.position).unit
  end

  def remove_tracking(hunter, wayfinding)
    @tracking.delete(hunter)
  end
  def add_tracking(hunter, wayfinding)
    raise "#{hunter.class} needs to define tracking_target" unless hunter.respond_to?(:tracking_target)
    @tracking[hunter] = wayfinding
  end
end
