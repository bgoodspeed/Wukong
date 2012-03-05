# To change this template, choose Tools | Templates
# and open the template in the editor.

class VectorFollower
  def initialize(start, vector, velocity)
    @start = start
    @vector = vector
    @velocity = velocity
    @current_step = 0
  end
  def tick
    @current_step += 1
  end
  def current_position
    @start.plus(@vector.scale(@current_step * @velocity))
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

  def add_projectile(start, theta, velocity)
    vector = start
    vector = []
    vector[0] = Gosu::offset_x(theta, 1) #TODO isolate all gosu references
    vector[1] = Gosu::offset_y(theta, 1)

    @vector_following << VectorFollower.new(start, vector, velocity)
  end
end
