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


end


class RenderingController

  def initialize(game)
    @game = game
    @mapping = {Primitives::LineSegment => Views::LineSegmentView.new(@game),
               Player => Views::PlayerView.new(@game),
               Enemy => Views::EnemyView.new(@game),
               EventArea => Views::EventAreaView.new(@game),
               InfoWindow => Views::InfoWindowView.new(@game),
               Weapon => Views::WeaponView.new(@game),
               #MouseCollisionWrapper => lambda {|screen, enemy| puts "NOOP, could add a highlight?" },
               #TODO ugly, should this be here? not sure about design
               VectorFollower => Views::VectorFollowerView.new(@game)
    }
    
  end

    include UtilityDrawing
  def draw_function_for(elem)
    #TODO move all drawing logic out of models in case we replace gosu
    raise "Unknown draw function for #{elem.class}" unless @mapping.has_key?(elem.class)
    @mapping[elem.class]
  end

end
