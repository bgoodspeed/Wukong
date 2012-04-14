# To change this template, choose Tools | Templates
# and open the template in the editor.

class Animation
  attr_reader :animation_index
  def initialize(gosu_anim)
    @gosu_anim = gosu_anim
    @animation_index = 0

  end

  def frames
    @gosu_anim.size
  end
  def image
    @gosu_anim[@animation_index % frames]
  end
  def tick
    @animation_index =  (@animation_index + 1 ) % frames
  end
end

class AnimationController
  def initialize(game, animation_rate=1)
    @game = game
    @animations = {}
    @animation_rate=animation_rate
    @ticks = 0
  end
  def animations_for(entity)
    @animations[entity] = {} if @animations[entity].nil?
    @animations[entity]
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
      animation.tick
    end
  end

  def position_for(entity, name)
    entity.animation_position_by_name(name)
  end
  include UtilityDrawing
  def draw(screen)
    visit do |entity, name, animation|
      position = position_for(entity, name)
      
      draw_animation_at(screen, position, animation)
    end
  end

  def tick
    @ticks += 1
    if (@ticks >= @animation_rate)
      @ticks = 0
      tick_animations
    end
  end
  #TODO hardcoded sizes
  def load_animation(entity, name, animation,w=25, h=25, tiles=false)
    gi = Graphics::Image::load_tiles(@game.window, animation, w,h,tiles) 
    animations_for(entity)[name] = Animation.new(gi)
  end
  def animation_index_by_entity_and_name(entity, name)
    animations_for(entity)[name]
  end
end
