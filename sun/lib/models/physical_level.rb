
# Convenience method for converting from radians to a Vec2 vector.
class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

class PhysicalCore

end

class TurretBullet
  attr_reader :shape
  def initialize(shape)
    @shape = shape
  end

  def effective_stats
    s = Stats.zero
    s.strength = @shape.body.m
    s
  end

  def p
    @shape.body.p
  end

  def body
    @shape.body
  end
  def reset_forces
    @shape.body.reset_forces
  end
end


class EnemyShip
  include Health
  attr_reader :shape
  def initialize(game, shape)
    @game = game
    @shape = shape
    @stats = Stats.zero
    @stats.health = 10
  end
  def health
    @stats.health
  end
  def effective_stats
    s = Stats.zero
    #TODO need to wire in physical properties such as force/mass/etc to determine stats
    #TODO use stat mapper
    s
  end

end

class Turret
  include YamlHelper
  ATTRIBUTES = [ :angle_delta, :angle_max, :angle_min, :power_delta, :power_min, :power_max, :x, :y]
  ALL_ATTRIBUTES = ATTRIBUTES + [:power, :angle]
  ALL_ATTRIBUTES.each {|attr| attr_accessor attr}
  def initialize(game, conf)
    @game = game

    process_attributes(ATTRIBUTES, self, conf)
    @power = @power_min + (@power_max - @power_min)/2.0
    @angle = @angle_min + (@angle_max - @angle_min)/2.0
  end

  def increase_angle
    @angle += @angle_delta
    @angle = [@angle, @angle_max].min
  end
  def decrease_angle
    @angle -= @angle_delta
    @angle = [@angle, @angle_min].max
  end

  def increase_power
    @power += @power_delta
    @power = [@power, @power_max].min
  end
  def decrease_power
    @power -= @power_delta
    @power = [@power, @power_min].max
  end

  def vector_for(angle)
    (angle * Math::PI/180).radians_to_vec2
  end
  def fire
    v = vector_for(@angle)
    v *= @power * 2
    v.y *= -1
    @game.level.physics.add_turret_bullet(@x, @y, v)
  end
end

class EnemyBase
  include Health
  attr_reader :shape, :stats
  def initialize(game, shape)
    @game = game
    @shape = shape
    @stats = Stats.zero
    @stats.health = 200

  end
  def effective_stats
    s = Stats.zero
    #TODO need to wire in physical properties such as force/mass/etc to determine stats
    #TODO use stat mapper
    s
  end

end

class PlayerBase < EnemyBase

end

module PhysicalObjectFactory
  def add_enemy_ship(conf)
    body = CP::Body.new(conf["mass"], conf["moment"])
    body.p = CP::Vec2.new(conf["px"], conf["py"])
    body.v = CP::Vec2.new(conf["vx"], conf["vy"])
    #TODO hardcoded poly shape for ship
    shape_array = [CP::Vec2.new(-25.0, 0.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 5.0), CP::Vec2.new(25.0, 4.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :enemy

    e = EnemyShip.new(self, shape)
    shape.object = e
    @space.add_body(body)
    @space.add_shape(shape)

    #joint = CP::Constraint::SlideJoint.new(@top_wall_body, body,
    #                                        @top_wall_body.world2local(CP::Vec2.new(SCREEN_WIDTH-50, 0)),
    #                                        body.world2local(body.p), 0, 350)
    #joint = CP::Constraint::PinJoint.new(@top_wall_body, body,
    #                                        @top_wall_body.world2local(CP::Vec2.new(SCREEN_WIDTH-50, 0)),
    #                                        body.world2local(body.p))
    joint = CP::Constraint::GrooveJoint.new(@top_wall_body, body,
                                            @top_wall_body.world2local(CP::Vec2.new(0,30)),
                                            @top_wall_body.world2local(CP::Vec2.new(@game.screen.width, 0)),
                                            CP::Vec2.new(1,1))
    joint.max_force = 100
    @space.add_constraint(joint)
    e
  end

  def build_base(mass, moment, px, py, minx, miny, maxx, maxy)
    body = Physics::Body.new(mass, moment)
    body.p = Physics::Vec2.new(px, py)
    shape_array = [Physics::Vec2.new(minx, miny), Physics::Vec2.new(minx, maxy), Physics::Vec2.new(maxx, maxy), Physics::Vec2.new(maxx,miny)]
    shape = Physics::Shape::Poly.new(body, shape_array, Physics::Vec2.new(0,0))
    shape.collision_type = :base
    @space.add_body(body)
    @space.add_shape(shape)
    shape
  end

  def add_enemy_base(mass, moment, px, py, minx, miny, maxx, maxy)
    shape = build_base(mass, moment, px, py, minx, miny, maxx, maxy)
    e = EnemyBase.new(@game, shape)
    @enemy_base = e
    shape.object = e
    @bases << e
  end
  def add_turret_bullet(x,y, v, v_scale = 1.17, f_scale=2.4)
    bullet = CP::Body.new(current_bullet_config["mass"], current_bullet_config["moment"])
    bullet.p = CP::Vec2.new(x, y)
    # angle * 180 / PI.radians_to... ?
    # v = angle.radians_to_vec2
    bullet.v = v * v_scale

    #bullet.force = v * 50
    bullet.apply_force(v * f_scale, CP::Vec2.new(0,0))
    shape = CP::Shape::Circle.new(bullet, 10)
    shape.collision_type = :bullet
    @space.add_body(bullet)
    @space.add_shape(shape)

    bo = TurretBullet.new(shape)
    shape.object = bo

    @bullets << bo
  end
  def make_drop_line(p1, p2)
    #seg_body = CP::Body.new(2, 3)
    seg_body = CP::Body.new_static
    seg_body.p = p1
    seg = CP::Shape::Segment.new(seg_body, CP::Vec2.new(0,0), p2 - p1, 10.0)
    seg.collision_type = :drop_line
    #@space.add_body(seg_body) #
    @space.add_shape(seg)
    seg_body
  end


  def make_wall(p1, p2)
    seg_body = Physics::Body.new_static
    seg_body.p = p1
    seg = Physics::Shape::Segment.new(seg_body, Physics::Vec2.new(0,0), p2 - p1, 1.0)
    seg.collision_type = :wall
    @space.add_shape(seg)
    seg_body
  end
end

class PhysicalLevel
  include YamlHelper
  include PhysicalObjectFactory
  SUBSTEPS = 9
  ATTRIBUTES = [:gravity, :damping, :steps, :drop_line_location]
  ATTRIBUTES.each {|attr| attr_accessor(attr)}
  attr_reader :space, :top_wall_body, :enemy_base, :player_base, :bases, :bullets, :turret, :drop_line, :enemies,
              :payloads, :enemies_killed, :bullets_to_remove, :bases_destroyed, :payloads_to_add, :payloads_to_remove
  def initialize(game, conf)
    @game = game
    process_attributes(ATTRIBUTES, self, conf, {:gravity => Finalizers::GVectorFinalizer.new})
    @space = Physics::Space.new
    @space.gravity = Physics::Vec2.new(@gravity.x, @gravity.y) if @gravity
    @space.damping = @damping if @damping
    @bullets = []
    @payloads = []
    @enemies = []
    @bases = []
    @enemies_killed  = []
    @bullets_to_remove = []
    @bases_destroyed = []
    @payloads_to_add = []
    @payloads_to_remove = []

    @dt = (1.0/@game.clock.target_framerate)

    make_wall(Physics::Vec2.new(@game.screen.width ,0), Physics::Vec2.new(@game.screen.width , @game.screen.height ))
    make_wall(Physics::Vec2.new(0,0), Physics::Vec2.new(0, @game.screen.height ))
    @top_wall_body = make_wall(Physics::Vec2.new(0,0), Physics::Vec2.new(@game.screen.width , 0))
    make_wall(Physics::Vec2.new(0,@game.screen.height), Physics::Vec2.new(@game.screen.width , @game.screen.height ))

    @drop_line = make_drop_line(CP::Vec2.new(@drop_line_location ,0), CP::Vec2.new(@drop_line_location, @game.screen.height))

    add_player_base_conf(conf["player_base"])
    add_enemy_base_conf(conf["enemy_base"])
    @conf = conf
    @enemies << add_enemy_ship(conf["enemy_ship"])
    @turret = Turret.new(@game, conf["turret"])

    @space.add_collision_func(:bullet, :wall) do |bullet, wall|
      @bullets_to_remove << bullet.object
    end

    @space.add_collision_func(:bullet, :enemy) do |bullet, enemy|
      enemy.object.take_damage(bullet.object)
      @bullets_to_remove << bullet.object
      if (enemy.object.dead?)
        @payloads_to_add += add_payload_drop_at(enemy.object.shape.body.p.x,enemy.object.shape.body.p.y, enemy.object.shape.body.m )
        @enemies_killed << enemy.object

      end
    end
    @space.add_collision_func(:bullet, :base) do |bullet, base|
      base.object.take_damage(bullet.object)
      @bullets_to_remove << bullet.object
      if (base.object.dead?)
        @bases_destroyed << base.object
      end
    end
  end


  def outside?(b)
    (b.p.x < 0) || (b.p.x > @game.screen.width) || (b.p.y < 0) || (b.p.y > @game.screen.height)
  end
  def update
    # Step the physics environment SUBSTEPS times each update
    SUBSTEPS.times do

      #@payloads_to_add.each {|pl|
      #  @payloads << pl
      #  @space.add_body(pl.body)
      #  @space.add_shape(pl.shape)
      #}
      #@payloads_to_add.clear
      #
      @bullets_to_remove.each {|e|
        @space.remove_shape(e.shape)
        @space.remove_body(e.body)
      }
      @bullets -= @bullets_to_remove
      @bullets_to_remove.clear
      #
      #@payloads_to_remove.each {|p|
      #  @space.remove_shape(p.shape)
      #  @space.remove_body(p.body)
      #}
      #@payloads -= @payloads_to_remove
      #@payloads_to_remove.clear
      #
      #@enemies_killed.each {|e| @space.remove_object(e.shape)}
      #@enemies -= @enemies_killed
      #@enemies_killed.clear
      # When a force or torque is set on a Body, it is cumulative
      # This means that the force you applied last SUBSTEP will compound with the
      # force applied this SUBSTEP; which is probably not the behavior you want
      # We reset the forces on the Player each SUBSTEP for this reason
      @enemies.each {|enemy| enemy.shape.body.reset_forces }


      expired = @bullets.select {|b| outside?(b)}
      expired.each {|b| @space.remove_body(b)}
      @bullets -= expired
      @bullets.each {|b| b.reset_forces}
      # @enemies.each {|e| e.validate_position}

      # Perform the step over @dt period of time
      # For best performance @dt should remain consistent for the game
      @space.step(@dt)
    end

    #if @enemies.empty?
    #  add_enemy_ship
    #end



  end

  def current_bullet_config
    { "mass" => 5, "moment" => 1}
  end


  def add_player_base_conf(conf)
    add_player_base(conf["mass"], conf["moment"], conf["px"], conf["py"], conf["minx"], conf["miny"],conf["maxx"],conf["maxy"],)
  end
  def add_enemy_base_conf(conf)
    add_enemy_base(conf["mass"], conf["moment"], conf["px"], conf["py"], conf["minx"], conf["miny"],conf["maxx"],conf["maxy"],)
  end
  def add_player_base(mass, moment, px, py, minx, miny, maxx, maxy)
    shape = build_base(mass, moment, px, py, minx, miny, maxx, maxy)
    e = PlayerBase.new(@game, shape)
    @player_base = e
    shape.object = e
    @bases << e
  end

  def physical_core_from(conf)
    if conf["static"]
      body = Physics::Body.new_static
    else
      body = Physics::Body.new(conf["mass"], conf["moment"])
    end

  end


end