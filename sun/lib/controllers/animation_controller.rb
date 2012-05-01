# To change this template, choose Tools | Templates
# and open the template in the editor.

class Animation
  attr_accessor:active
  attr_reader :animation_index, :width, :height, :needs_update
  def initialize(gosu_anim, active=true, animation_rate=nil, needs_update=true)
    @gosu_anim = gosu_anim
    @width = gosu_anim.first.width
    @height = gosu_anim.first.height
    @animation_index = 0
    @active = active
    @ticks = 0
    @animation_rate = animation_rate ? animation_rate : 1
    @needs_update = needs_update
  end

  def frames
    @gosu_anim.size
  end
  def image
    @gosu_anim[@animation_index % frames]
  end
  def tick
    @ticks += 1
    if (@ticks >= @animation_rate)
      @ticks = 0
      @animation_index =  (@animation_index + 1 ) % frames
    end
  end
end

class AnimationController
  attr_reader :animations
  def initialize(game, animation_rate=1)
    @game = game
    @animation_rate=animation_rate
    clear
  end

  def clear
    @animations = {}
    @equivalent = {}
  end
  def animations_for(entity)
    eq = @equivalent.has_key?(entity) ? @equivalent[entity] : entity
    @animations[eq] = {} if @animations[eq].nil?
    @animations[eq]
  end

  def add_entity_equivalance(e1, e2)
    @equivalent[e1] = e2
  end

  def visit
    @animations.each {|entity,names|
      names.each {|name,animation|
        yield entity, name, animation
      }
    }

  end
  def tick_animations
    visit do |entity, name, animation|
      next unless animation.active or animation.needs_update
      animation.tick
    end
  end

  def position_for(entity, name)
    entity.animation_position_by_name(name)
  end
  include UtilityDrawing
  def draw(screen)
    visit do |entity, name, animation|
      next unless animation.active
      draw_one(screen, entity, name)
    end
  end
  def draw_one_rotated(screen, entity, name)
    animation = animations_for(entity)[name]
    world_position = position_for(entity, name)
    position = @game.camera.screen_coordinates_for(world_position)
    draw_animation_rotated_at(screen, position, entity.direction, animation)

  end
  def draw_one(screen, entity, name)
    animation = animations_for(entity)[name]
    world_position = position_for(entity, name)
    position = @game.camera.screen_coordinates_for(world_position)
    draw_animation_at(screen, position, animation)
    
  end
  def tick
    tick_animations
  end

  def play_animation(entity, name)
    animations_for(entity)[name].active = true
  end
  def stop_animation(entity, name)
    animations_for(entity)[name].active = false
  end

  #TODO load_animation should go away, replaced with register, play and stop
  #TODO hardcoded sizes
  def load_animation(entity, name, animation,w=25, h=25, tiles=false, active=false,rate=1)
    register_animation(entity, name, animation,w, h, tiles, true, rate)
    play_animation(entity, name)
  end
  
  def register_animation(entity, name, animation,w=25, h=25, tiles=false, active=false, rate=1)
    gi = Graphics::Image::load_tiles(@game.window, animation, w,h,tiles)
    animations_for(entity)[name] = Animation.new(gi, active, rate)
  end
  
  def animation_index_by_entity_and_name(entity, name)
    animations_for(entity)[name]
  end
end
