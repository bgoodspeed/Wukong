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

class Turret
  def initialize(window)
    @window = window
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @angle = 45
    @angle_delta = 1
    @angle_max = 90
    @angle_min = 0
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

  def vector_for(angle)
    #(angle * 180/Math::PI).radians_to_vec2
    (angle * Math::PI/180).radians_to_vec2
    #angle.radians_to_vec2

  end
  def fire

    v = vector_for(@angle)

    v *= 100

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
  attr_reader :shape
  include ScreenClamped
  def initialize(window, shape)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @shape = shape
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    @turret = Turret.new(window)
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is actually
    # the bottom; thus 3PI/2 is the top
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
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

  # Directly set the position of our Player
  def warp(vect)
    @shape.body.p = vect
  end

  # Apply negative Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_left
    @shape.body.t -= 400.0/SUBSTEPS
  end

  # Apply positive Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  def turn_right
    @shape.body.t += 400.0/SUBSTEPS
  end

  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply
  def accelerate
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end

  # Apply even more forward force
  # See accelerate for more details
  def boost
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (3000.0)), CP::Vec2.new(0.0, 0.0))
  end

  # Apply reverse force
  # See accelerate for more details
  def reverse
    @shape.body.apply_force(-(@shape.body.a.radians_to_vec2 * (1000.0/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end



  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
    @turret.draw
  end
end

# See how simple our Star is?
# Of course... it just sits around and looks good...
class Star
  attr_reader :shape

  def initialize(animation, shape)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
    @shape = shape
    @shape.body.p = CP::Vec2.new(rand * SCREEN_WIDTH, rand * SCREEN_HEIGHT) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
    @shape.body.a = (3*Math::PI/2.0) # angle in radians; faces towards top of screen
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@shape.body.p.x - img.width / 2.0, @shape.body.p.y - img.height / 2.0, ZOrder::Stars, 1, 1, @color, :add)
  end
end

class EnemyShip
  include ScreenClamped
  attr_reader :shape
  def initialize(window, shape)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @shape = shape
  end
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
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

  def clamp_walls
    make_wall(CP::Vec2.new(SCREEN_WIDTH ,0), CP::Vec2.new(SCREEN_WIDTH , SCREEN_HEIGHT ))
    make_wall(CP::Vec2.new(0,0), CP::Vec2.new(0, SCREEN_HEIGHT ))
    @top_wall_body = make_wall(CP::Vec2.new(0,0), CP::Vec2.new(SCREEN_WIDTH , 0))
    make_wall(CP::Vec2.new(0,SCREEN_HEIGHT), CP::Vec2.new(SCREEN_WIDTH , SCREEN_HEIGHT ))
  end

  def add_gravity
    @space.gravity = CP::Vec2.new(0, 5.0)
  end

  def add_turret_bullet(x,y, v)
    bullet = CP::Body.new(5, 0)
    bullet.p = CP::Vec2.new(x, y)

    # angle * 180 / PI.radians_to... ?

    # v = angle.radians_to_vec2
    bullet.v = v

    #bullet.force = v * 50
    bullet.apply_force(v * 50, CP::Vec2.new(0,0))
    shape = CP::Shape::Circle.new(bullet, 10)
    shape.collision_type = :bullet

    @bullets << bullet
    @space.add_body(bullet)
    @space.add_shape(shape)
  end

  def add_enemy_ship
    body = CP::Body.new(10.0, 150.0)
    body.p = CP::Vec2.new(SCREEN_WIDTH-50, 50)
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

    shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 5.0), CP::Vec2.new(25.0, -5.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    shape.collision_type = :enemy
    e = EnemyShip.new(self, shape)
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
    @space.damping = 0.8

    add_gravity
    clamp_walls
    @enemies = []
    @bullets = []
    add_enemy_ship
    # Create the Body for the Player
    body = CP::Body.new(10.0, 150.0)

    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use s simple, 4 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
    shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))

    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    shape.collision_type = :ship

    @space.add_body(body)
    @space.add_shape(shape)

    @player = Player.new(self, shape)
    @player.warp(CP::Vec2.new(320, 240)) # move to the center of the window

    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 25, 25, false)
    @stars = Array.new

    # Here we define what is supposed to happen when a Player (ship) collides with a Star
    # I create a @remove_shapes array because we cannot remove either Shapes or Bodies
    # from Space within a collision closure, rather, we have to wait till the closure
    # is through executing, then we can remove the Shapes and Bodies
    # In this case, the Shapes and the Bodies they own are removed in the Gosu::Window.update phase
    # by iterating over the @remove_shapes array
    # Also note that both Shapes involved in the collision are passed into the closure
    # in the same order that their collision_types are defined in the add_collision_func call
    @remove_shapes = []
    @space.add_collision_func(:ship, :star) do |ship_shape, star_shape|
      @score += 10
      @beep.play
      @remove_shapes << star_shape
    end


    # Here we tell Space that we don't want one star bumping into another
    # The reason we need to do this is because when the Player hits a Star,
    # the Star will travel until it is removed in the update cycle below
    # which means it may collide and therefore push other Stars
    # To see the effect, remove this line and play the game, every once in a while
    # you'll see a Star moving
    @space.add_collision_func(:star, :star, &nil)
  end

  def update
    # Step the physics environment SUBSTEPS times each update
    SUBSTEPS.times do
      # This iterator makes an assumption of one Shape per Star making it safe to remove
      # each Shape's Body as it comes up
      # If our Stars had multiple Shapes, as would be required if we were to meticulously
      # define their true boundaries, we couldn't do this as we would remove the Body
      # multiple times
      # We would probably solve this by creating a separate @remove_bodies array to remove the Bodies
      # of the Stars that were gathered by the Player
      @remove_shapes.each do |shape|
        @stars.delete_if { |star| star.shape == shape }
        @space.remove_body(shape.body)
        @space.remove_shape(shape)
      end
      @remove_shapes.clear # clear out the shapes for next pass

      # When a force or torque is set on a Body, it is cumulative
      # This means that the force you applied last SUBSTEP will compound with the
      # force applied this SUBSTEP; which is probably not the behavior you want
      # We reset the forces on the Player each SUBSTEP for this reason
      @player.shape.body.reset_forces

      @enemies.each {|enemy| enemy.shape.body.reset_forces }

      # Wrap around the screen to the other side
      @player.validate_position

      @enemies.each {|e| e.validate_position}
      # Check keyboard
      if button_down? Gosu::KbLeft
        @player.turn_left
      end


      if button_down? Gosu::KbRight
        @player.turn_right
      end

      if button_down? Gosu::KbUp
        if ( (button_down? Gosu::KbRightShift) || (button_down? Gosu::KbLeftShift) )
          @player.boost
        else
          @player.accelerate
        end
      elsif button_down? Gosu::KbDown
        @player.reverse
      end

      # Perform the step over @dt period of time
      # For best performance @dt should remain consistent for the game
      @space.step(@dt)
    end


    if button_down? Gosu::KbW
      @player.move_turret_up
    end
    if button_down? Gosu::KbS
      @player.move_turret_down
    end

    m = Gosu::milliseconds
    @fire_delay = 300
    if button_down? Gosu::KbSpace and (@last_fired_time.nil? or ((m - @last_fired_time ) > @fire_delay))
      @player.fire_turret
      @last_fired_time = m
    end
    # Each update (not SUBSTEP) we see if we need to add more Stars
    if rand(100) < 4 and @stars.size < 25 then
      body = CP::Body.new(0.0001, 0.0001)
      shape = CP::Shape::Circle.new(body, 25/2, CP::Vec2.new(0.0, 0.0))
      shape.collision_type = :star

      @space.add_body(body)
      @space.add_shape(shape)

      @stars.push(Star.new(@star_anim, shape))
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @enemies.each { |e| e.draw }
    @bullets.each { |b| @bullet_image.draw(b.p.x, b.p.y, ZOrder::UI) }
    @font.draw("Score: #{@score} (#{@player.shape.body.p})", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show