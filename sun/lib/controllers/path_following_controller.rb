# To change this template, choose Tools | Templates
# and open the template in the editor.


class PathFollowingController
  attr_accessor :distance_threshold
  attr_reader :vector_following, :tracking
  def initialize(game)
    @game = game
    @vector_following = []
    @tracking = {}
    @distance_threshold = 500 #TODO make this configurable
  end

  def tick
    @vector_following.each {|vf|
      vf.tick
    }

    vfs = @vector_following.select {|vf| vf.distance_from_start > @distance_threshold}
    vfs.each {|vf| @game.remove_projectile(vf) }

    @tracking.each {|h, wf|
      if h.position.distance_from(@game.player.position) > @distance_threshold

      else
        h.tick_tracking(current_tracking_direction_for(h))
      end

    }
  end
  def remove_projectile(p)
    @vector_following -= [p]
  end
  def add_projectile(owner, start, theta, velocity)
    vector = start
    vector = []
    vector[0] = Graphics::offset_x(theta, 1) #TODO isolate all gosu references
    vector[1] = Graphics::offset_y(theta, 1)
    vf = VectorFollower.new(start, vector, velocity, owner)

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
