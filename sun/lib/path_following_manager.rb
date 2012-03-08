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
  def collision_type
    self.class
  end
  def collision_radius
    @velocity
  end
  def collision_center
    current_position
  end
end

class PathFollowingManager
  attr_reader :vector_following
  def initialize(game)
    @game = game
    @vector_following = []
  end

  def tick
    @vector_following.each {|vf| vf.tick}
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
end
