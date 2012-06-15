require 'rubygems'
require 'gosu'
require 'chipmunk'

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

# The number of steps to process every Gosu update
# The Player ship can get going so fast as to "move through" a
# star without triggering a collision; an increased number of
# Chipmunk step calls per update will effectively avoid this issue
SUBSTEPS = 9

# Convenience method for converting from radians to a Vec2 vector.
class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

# Layering of sprites
module ZOrder
  Background, Stars, Player, UI = *0..3
end

module ScreenClamped
  # Wrap to the other side of the screen when we fly off the edge
  def validate_position
    xs = [@shape.body.p.x, SCREEN_WIDTH].min
    ys = [@shape.body.p.y, SCREEN_HEIGHT].min

    x = [0, xs].max
    y = [0, ys].max

    l_position = CP::Vec2.new(x,y)
    @shape.body.p = l_position
  end
end

class TurretBullet
  attr_reader :shape
  def initialize(shape)
    @shape = shape
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
class Turret
  attr_reader :angle, :power
  def initialize(window)
    @window = window
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @angle = 45
    @angle_delta = 1
    @angle_max = 90
    @angle_min = 0
    @power = 50
    @power_delta = 1
    @power_min = 20
    @power_max = 110
    @x = 30
    @y = SCREEN_HEIGHT - 30

  end

  def increase_angle
    @angle += @angle_delta
    @angle = [@angle, @angle_max].min
  end
  def decrease_angle
    @angle -= @angle_delta
    @angle = [@angle, @angle_min].max
  end

  def power_up
    @power += @power_delta
    @power = [@power, @power_max].min
  end
  def power_down
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
    @window.add_turret_bullet(@x, @y, v)
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, 90 - @angle)
    v = vector_for(@angle)
    v *= 100

    @window.draw_line(@x, @y,  Gosu::Color::WHITE,
                     @x + v.x, @y -  v.y,
                      Gosu::Color::WHITE,
                      ZOrder::UI)
  end
end

# This game will have one Player in the form of a ship
class Player
  attr_reader :turret
  include ScreenClamped
  def initialize(window)
    @turret = Turret.new(window)
  end

  def fire_turret
    @turret.fire
  end
  def move_turret_up
    @turret.increase_angle
  end

  def move_turret_down
    @turret.decrease_angle
  end

  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
#  def accelerate
#    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
#  end

  # Apply even more forward force
  # See accelerate for more details
  def boost
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end

  def draw
    @turret.draw
  end
end


class EnemyShip
  include ScreenClamped
  attr_reader :shape, :health
  def initialize(window, shape)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @shape = shape
    @health = 75
  end

  def dead?
    @health <= 0
  end

  def take_damage(m)
    @health -= m
    puts "enemy ship health now #{@health}"
    # bullet.body.v, bullet.body.m
  end


  def w
    if @w.nil?
      @w = @image.width/2.0
    end
    @w
  end
  def h
    if @h.nil?
      @h = @image.height/2.0
    end
    @h
  end
  def draw
    @image.draw_rot(@shape.body.p.x + w , @shape.body.p.y + h, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
end

class EnemyBase
  include ScreenClamped
  attr_reader :shape, :health
  def initialize(window, shape)
    @window = window
    @shape = shape
    @health = 1000
  end

  def dead?
    @health <= 0
  end

  def take_damage(m)
    @health -= m
    puts "enemy base health now #{@health}"
    # bullet.body.v, bullet.body.m
  end

  def color
    Gosu::Color::RED
  end
  def draw
    @dx = 60
    @dy = 20
    @window.draw_quad(@shape.body.p.x, @shape.body.p.y, color,
                      @shape.body.p.x + @dx, @shape.body.p.y, color,
                      @shape.body.p.x + @dx, @shape.body.p.y + @dy, color,
                      @shape.body.p.x, @shape.body.p.y + @dy, color, ZOrder::Player)

#    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)

  end
end

class PlayerBase < EnemyBase
  def take_damage(m)
    @health -= m
    puts "player base health now #{@health}"
    # bullet.body.v, bullet.body.m
  end
  def color
    Gosu::Color::GREEN
  end

end


# The Gosu::Window is always the "environment" of our game
# It also provides the pulse of our game
class GameWindow < Gosu::Window

  def make_wall(p1, p2)
    seg_body = CP::Body.new_static
    seg_body.p = p1
    seg = CP::Shape::Segment.new(seg_body, CP::Vec2.new(0,0), p2 - p1, 1.0)
    seg.collision_type = :wall
    #@space.add_body(seg_body)
    @space.add_shape(seg)
    seg_body
  end

  def make_drop_line(p1, p2)
    seg_body = CP::Body.new(1, 1)
    seg_body.p = p1
    seg = CP::Shape::Segment.new(seg_body, CP::Vec2.new(0,0), p2 - p1, 1.0)
    seg.collision_type = :drop_line
    @space.add_body(seg_body)
    @space.add_shape(seg)
    seg_body
  end

  def add_drop_line(x=@drop_line_location)
    @drop_line = make_wall(CP::Vec2.new(x ,0), CP::Vec2.new(x, SCREEN_HEIGHT ))
  end

  def clamp_walls
    make_wall(CP::Vec2.new(SCREEN_WIDTH ,0), CP::Vec2.new(SCREEN_WIDTH , SCREEN_HEIGHT ))
    make_wall(CP::Vec2.new(0,0), CP::Vec2.new(0, SCREEN_HEIGHT ))
    @top_wall_body = make_wall(CP::Vec2.new(0,0), CP::Vec2.new(SCREEN_WIDTH , 0))
    make_wall(CP::Vec2.new(0,SCREEN_HEIGHT), CP::Vec2.new(SCREEN_WIDTH , SCREEN_HEIGHT ))
  end

  def add_gravity
    @space.gravity = CP::Vec2.new(0, 5.0)
  end

  def add_enemy_base
    body = CP::Body.new(10.0, 250.0)
    body.p = CP::Vec2.new(SCREEN_WIDTH-250, SCREEN_HEIGHT - 50)


    shape_array = [CP::Vec2.new(-25.0, 0.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 25.0), CP::Vec2.new(25.0, 0.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :base

    e = EnemyBase.new(self, shape)
    shape.object = e
    @bases << e
    @space.add_body(body)
    @space.add_shape(shape)

  end
  def add_player_base
    body = CP::Body.new(10.0, 250.0)
    body.p = CP::Vec2.new(120, SCREEN_HEIGHT - 50)
    shape_array = [CP::Vec2.new(-25.0, 0.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 25.0), CP::Vec2.new(25.0, 0.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :base

    e = PlayerBase.new(self, shape)
    shape.object = e
    @bases << e
    @space.add_body(body)
    @space.add_shape(shape)

  end

  def add_turret_bullet(x,y, v, v_scale = 1.17, f_scale=2.4)
    bullet = CP::Body.new(5, 1)
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

  def add_enemy_ship
    body = CP::Body.new(10.0, 150.0)
    body.p = CP::Vec2.new(SCREEN_WIDTH-70, 90)
    body.v = CP::Vec2.new(-0.05, 0.0)

    #body.velocity_func do |body, gravity, damping, dt|
    #end
    #body.velocity_func do |body, gravity, damping, dt|
    #  dv = body.v * damping
    #  fi = body.f * body.m_inv
    #  fid = fi * dt
    #  v = dv + fid
    #  rv = v.clamp(body.v_limit)
    #  body.v = rv
    #  i_inv = 1.0/body.i
    #  body.w = CP.clamp(body.w * damping + body.t * i_inv*dt, -body.w_limit, body.w_limit)
    #  rv
    #end

    shape_array = [CP::Vec2.new(-25.0, 0.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 5.0), CP::Vec2.new(25.0, 4.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :enemy

    e = EnemyShip.new(self, shape)
    shape.object = e
    @enemies << e
    @space.add_body(body)
    @space.add_shape(shape)

    #joint = CP::Constraint::SlideJoint.new(@top_wall_body, body,
    #                                        @top_wall_body.world2local(CP::Vec2.new(SCREEN_WIDTH-50, 0)),
    #                                        body.world2local(body.p), 0, 350)
    #joint = CP::Constraint::PinJoint.new(@top_wall_body, body,
    #                                        @top_wall_body.world2local(CP::Vec2.new(SCREEN_WIDTH-50, 0)),
    #                                        body.world2local(body.p))
    joint = CP::Constraint::GrooveJoint.new(@top_wall_body, body,
                                            @top_wall_body.world2local(CP::Vec2.new(-1,30)),
                                            @top_wall_body.world2local(CP::Vec2.new(SCREEN_WIDTH, 0)),
                                            CP::Vec2.new(1,1))
    @space.add_constraint(joint)

  end
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false, 16)
    self.caption = "Gosu & Chipmunk Integration Demo"
    @background_image = Gosu::Image.new(self, "media/Space.png", true)
    @bullet_image = Gosu::Image.new(self, "media/bullet.png", true)

    # Put the beep here, as it is the environment now that determines collision
    @beep = Gosu::Sample.new(self, "media/Beep.wav")

    # Put the score here, as it is the environment that tracks this now
    @score = 0
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # Time increment over which to apply a physics "step" ("delta t")
    @dt = (1.0/60.0)

    # Create our Space and set its damping
    # A damping of 0.8 causes the ship bleed off its force and torque over time
    # This is not realistic behavior in a vacuum of space, but it gives the game
    # the feel I'd like in this situation
    @space = CP::Space.new
    @space.damping = 0.85

    @drop_line_location = 145
    add_gravity
    clamp_walls
    @bases = []
    @enemies = []
    @bullets = []
    add_enemy_ship
    add_enemy_base
    add_player_base
    @player = Player.new(self)

    @enemies_killed  = []
    @bullets_to_remove = []
    @bases_destroyed = []
    @space.add_collision_func(:bullet, :enemy) do |bullet, enemy|
      @score += 100
      enemy.object.take_damage(bullet.body.m)
      @bullets_to_remove << bullet.object
      if (enemy.object.dead?)
        @enemies_killed << enemy.object
      end
    end

    @space.add_collision_func(:bullet, :base) do |bullet, base|
      @score += 100
      base.object.take_damage(bullet.body.m)
      @bullets_to_remove << bullet.object
      if (base.object.dead?)
        @bases_destroyed << base.object
      end
    end

    @space.add_collision_func(:bullet, :wall) do |bullet, wall|
      @bullets_to_remove << bullet.object
    end
    @space.add_collision_func(:bullet, :bullet) do |bullet, bullet2|
      @bullets_to_remove << bullet.object
      @bullets_to_remove << bullet2.object
    end
    @space.add_collision_func(:enemy, :drop_line) do |enemy, drop_line|
      puts 'hit the drop line, do something'
    end



    #@space.add_collision_func(:ship, :star) do |ship_shape, star_shape|
    #  @score += 10
    #  @beep.play
    #  @remove_shapes << star_shape
    #end
    #@space.add_collision_func(:star, :star, &nil)
  end


  def outside?(b)
    (b.p.x < 0) || (b.p.x > SCREEN_WIDTH) || (b.p.y < 0) || (b.p.y > SCREEN_HEIGHT)
  end
  def update
    # Step the physics environment SUBSTEPS times each update
    SUBSTEPS.times do

      @bases_destroyed.each {|bd|
        puts 'base destroyed, do something with it'
      }

      @bullets_to_remove.each {|e|
        @space.remove_shape(e.shape)
        @space.remove_body(e.body)


      }
      @bullets -= @bullets_to_remove
      @bullets_to_remove.clear

      @enemies_killed.each {|e| @space.remove_object(e.shape)}
      @enemies -= @enemies_killed
      @enemies_killed.clear
      # When a force or torque is set on a Body, it is cumulative
      # This means that the force you applied last SUBSTEP will compound with the
      # force applied this SUBSTEP; which is probably not the behavior you want
      # We reset the forces on the Player each SUBSTEP for this reason
      @enemies.each {|enemy| enemy.shape.body.reset_forces }


      expired = @bullets.select {|b| outside?(b)}
      expired.each {|b| @space.remove_body(b)}
      @bullets -= expired
      @bullets.each {|b| b.reset_forces}
      @enemies.each {|e| e.validate_position}

      # Perform the step over @dt period of time
      # For best performance @dt should remain consistent for the game
      @space.step(@dt)
    end


    if button_down? Gosu::KbW or button_down? Gosu::KbUp
      @player.move_turret_up
    end
    if button_down? Gosu::KbS or button_down? Gosu::KbDown
      @player.move_turret_down
    end
    if button_down? Gosu::KbD or button_down? Gosu::KbRight
      @player.turret.power_up
    end
    if button_down? Gosu::KbA or button_down? Gosu::KbLeft
      @player.turret.power_down
    end

    m = Gosu::milliseconds
    @fire_delay = 300
    if button_down? Gosu::KbSpace and (@last_fired_time.nil? or ((m - @last_fired_time ) > @fire_delay))
      @player.fire_turret
      @last_fired_time = m
    end

  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @enemies.each { |e| e.draw }
    @bases.each {|b| b.draw }
    @bullets.each { |b| @bullet_image.draw(b.shape.body.p.x, b.shape.body.p.y, ZOrder::UI) }
    @font.draw("Angle (#{@player.turret.angle}) Power: #{@player.turret.power}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show