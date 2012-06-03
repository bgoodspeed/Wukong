# To change this template, choose Tools | Templates
# and open the template in the editor.

class LineOfSightQuery
  attr_accessor :a, :b, :vector, :radius, :collision_priority
  def initialize(game, a, b)
    @game = game
    @a = a
    @b = b
    @collision_priority = CollisionPriority::LOW
    @tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @tmp_min = GVector.xy(0,0)
  end

  def collision_response_type
    self.class.to_s
  end

  def to_collision
    Primitives::LineSegment.new(@a.position, @b.position)
  end
  def collision_radius
    c = to_collision
    c.p1.minus(@tmp, c.p2)
    @tmp.norm
  end

  def collision_center
    c = to_collision
    c.p1.minus(@tmp_min, c.p2)
    c.p2.plus(@tmp, @tmp_min)
    @tmp
  end

  def collision_type
    to_collision.collision_type
  end
end

class PathFollowingController
  attr_accessor :distance_threshold
  attr_reader :vector_following, :tracking
  def initialize(game)
    @game = game
    @vector_following = []
    @tracking = {}
    @distance_threshold = 500 #TODO make this configurable

    @tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @tmp_u = GVector.xy(0,0) #NOTE temporary vector allocation

  end

  def tick
    @vector_following.each {|vf|
      vf.tick
    }

    @game.level.remove_line_of_sight_queries

    vfs = @vector_following.select {|vf| vf.distance_from_start > @distance_threshold}
    vfs.each {|vf| @game.remove_projectile(vf) }

    @tracking.each {|h, wf|
      d = h.position.distance_from(@game.player.position)
      if d <= @distance_threshold

        @game.level.add_line_of_sight_query(LineOfSightQuery.new(@game, h, h.tracking_target))
        if d <= h.attack_range
          h.trigger_event(:enemy_in_range)
        else
          h.trigger_event(:enemy_too_far)
        end
        h.tick_tracking(current_tracking_direction_for(h))
      else
        h.trigger_event(:enemy_lost)
      end
    }
  end
  def remove_projectile(p)
    @vector_following -= [p]
  end
  def add_projectile(owner, start, theta, velocity)
    vector = GVector.xy(0,0)
    vector.x = Graphics::offset_x(theta, 1) #TODO isolate all gosu references
    vector.y = Graphics::offset_y(theta, 1)
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
    pt.minus(@tmp, hunter.position)
    @tmp.unit(@tmp_u)
    @tmp_u
  end

  def remove_tracking(hunter, wayfinding)
    @tracking.delete(hunter)
  end
  def add_tracking(hunter, wayfinding)
    raise "#{hunter.class} needs to define tracking_target" unless hunter.respond_to?(:tracking_target)
    @tracking[hunter] = wayfinding
  end
end
