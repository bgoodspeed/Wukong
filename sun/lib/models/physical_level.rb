
class PhysicalCore

end

class EnemyBase
  attr_reader :shape, :health
  def initialize(game, shape)
    @game = game
    @shape = shape
    @health = 200
  end

  def dead?
    @health <= 0
  end

  def take_damage(m)
    @health -= m
    puts "enemy base health now #{@health}"
    # bullet.body.v, bullet.body.m
  end

end

class PlayerBase < EnemyBase

end
class PhysicalLevel
  include YamlHelper
  ATTRIBUTES = [:gravity, :damping, :steps, :drop_line_location]
  ATTRIBUTES.each {|attr| attr_accessor(attr)}
  attr_reader :space, :top_wall_body, :enemy_base, :player_base, :bases, :bullets, :turret
  def initialize(game, conf)
    @game = game
    process_attributes(ATTRIBUTES, self, conf, {:gravity => Finalizers::GVectorFinalizer.new})
    @space = Physics::Space.new
    @space.gravity = Physics::Vec2.new(@gravity.x, @gravity.y) if @gravity
    @space.damping = @damping if @damping
    @bullets = []
    @bases = []
    make_wall(Physics::Vec2.new(@game.screen.width ,0), Physics::Vec2.new(@game.screen.width , @game.screen.height ))
    make_wall(Physics::Vec2.new(0,0), Physics::Vec2.new(0, @game.screen.height ))
    @top_wall_body = make_wall(Physics::Vec2.new(0,0), Physics::Vec2.new(@game.screen.width , 0))
    make_wall(Physics::Vec2.new(0,@game.screen.height), Physics::Vec2.new(@game.screen.width , @game.screen.height ))

    add_player_base_conf(conf["player_base"])
    add_enemy_base_conf(conf["enemy_base"])
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

  def make_wall(p1, p2)
    seg_body = Physics::Body.new_static
    seg_body.p = p1
    seg = Physics::Shape::Segment.new(seg_body, Physics::Vec2.new(0,0), p2 - p1, 1.0)
    seg.collision_type = :wall
    @space.add_shape(seg)
    seg_body
  end
end