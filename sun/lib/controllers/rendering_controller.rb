# To change this template, choose Tools | Templates
# and open the template in the editor.

module Views
  class BaseView
    include UtilityDrawing
    attr_reader :game
    def initialize(game)
      @game = game
    end
  end
  class LineSegmentView < BaseView
    def call(screen, linesegment)
      p1 = game.camera.screen_coordinates_for(linesegment.p1)
      p2 = game.camera.screen_coordinates_for(linesegment.p2)
      ls = Primitives::LineSegment.new(p1, p2)
      draw_line_segment(screen, ls, ZOrder.static.value, Graphics::Color::RED)
    end
  end

  class PlayerView < BaseView
    def call(screen, player)
      game.animation_controller.draw_one_rotated(screen, player, player.main_animation_name)
    end
  end

  class EnemyView < BaseView
    def call(screen, enemy)
      game.animation_controller.draw_one_rotated(screen, enemy, enemy.animation_name)
      
    end
  end
  class EventAreaView < BaseView
    def call(screen, ea)
      r = ea.rect
      rect = Primitives::Rectangle.new(game.camera.screen_coordinates_for(r.p1), game.camera.screen_coordinates_for(r.p2), game.camera.screen_coordinates_for(r.p3), game.camera.screen_coordinates_for(r.p4))
      #TODO this is getting messy
      msg_offset = [15,15]
      game.font_controller.draw_with_font(ea.label, rect.p1.x + msg_offset.x, rect.p1.y + msg_offset.y, ZOrder.hud.value)
      draw_rectangle_as_box(screen, rect,  ZOrder.static.value, color=Graphics::Color::BLACK)
    end
  end

  class InfoWindowView < BaseView
    def call(screen, iw)
      darken_screen(game, 50, game.window.width-50, 50, game.window.height-50)
      #TODO fix this ZOrder stupidity
      iw.description.each_with_index do |desc, idx|
        game.font_controller.draw_with_font(desc, 60, 60*(idx + 1), ZOrder.hud.value)
      end

      #TODO it seems we're actually being passed the event area, should be just the info window
      iw.info_window.images.each do |iwi|
        game.image_controller.draw_image(iwi)
      end
    end
  end
  class WeaponView < BaseView
    def call(screen, w)
      lsi = w.to_collision

      ls1 = game.camera.screen_coordinates_for(lsi.p1)
      ls2 = game.camera.screen_coordinates_for(lsi.p2)
      ls = Primitives::LineSegment.new(ls1,ls2)
      draw_line_segment(screen, ls)
    end
  end
  class VectorFollowerView < BaseView
    def call(screen, vf)
      d = 10
      cp = game.camera.screen_coordinates_for(vf.current_position)

      draw_rectangle(screen, Primitives::Rectangle.new(cp, cp.plus([d,0]), cp.plus([d,d]), cp.plus([0,d])))
      lsi = vf.to_collision

      ls1 = game.camera.screen_coordinates_for(lsi.p1)
      ls2 = game.camera.screen_coordinates_for(lsi.p2)
      ls = Primitives::LineSegment.new(ls1,ls2)
      draw_line_segment(screen, ls)
    end
  end
  class TemporaryRenderingView < BaseView
    def call(screen, tr)
      pos = game.camera.screen_coordinates_for(tr.position)
      w = tr.radius
      darken_screen(game, pos[0] - w, pos[0] + w, pos[1] - w, pos[1] + w, transparent_red, ZOrder.hud.value)
    end
  end

end

module RenderingTypes
  DAMAGE = "RENDER_DAMAGE"
end

class TemporaryRendering
  attr_reader :entity, :type, :time_to_live
  def initialize(entity, type, time_to_live)
    @entity, @type, @time_to_live = entity, type, time_to_live
  end

  def tick
    @time_to_live -= 1
  end
  def dead?
    @time_to_live <= 0
  end
  def position
    @entity.position
  end
  def radius
    @entity.radius
  end

end


class RenderingController
  attr_reader :temporary_renderings
  def initialize(game)
    @game = game
    @mapping = {Primitives::LineSegment => Views::LineSegmentView.new(@game),
               Player => Views::PlayerView.new(@game),
               Enemy => Views::EnemyView.new(@game),
               EventArea => Views::EventAreaView.new(@game),
               InfoWindow => Views::InfoWindowView.new(@game),
               Weapon => Views::WeaponView.new(@game),
               #MouseCollisionWrapper => lambda {|screen, enemy| puts "NOOP, could add a highlight?" },
               VectorFollower => Views::VectorFollowerView.new(@game),
              RenderingTypes::DAMAGE => Views::TemporaryRenderingView.new(@game)
    }

    @temporary_renderings = []
  end

  def add_consumable_rendering(entity, type, duration)
    @temporary_renderings << TemporaryRendering.new(entity, type, duration)
  end

  def tick
    @temporary_renderings.each {|tr|tr.tick}
    @temporary_renderings.reject!{|tr| tr.dead?}
  end

  def draw_temporary_renderings
    @temporary_renderings.each {|tr|
      raise "Unknown rendering type #{tr.type}" unless @mapping.has_key?(tr.type)
      @mapping[tr.type].call(@game, tr)
    }
  end

  include UtilityDrawing
  def draw_function_for(elem)
    raise "Unknown draw function for #{elem.class}" unless @mapping.has_key?(elem.class)
    @mapping[elem.class]
  end

end
