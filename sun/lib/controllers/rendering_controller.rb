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
      msg_offset = GVector.xy(15,15)
      game.font_controller.draw_with_font(ea.label, rect.p1.x + msg_offset.x, rect.p1.y + msg_offset.y, ZOrder.hud.value)
      draw_rectangle_as_box(screen, rect,  ZOrder.static.value, color=Graphics::Color::BLACK)
    end
  end

  class InfoWindowView < BaseView
    def call(screen, iw_in)
      return if game.menu_mode?
      iw = iw_in
      iw = iw_in.entity if iw_in.respond_to?(:entity)
      #TODO this is really hideous.
      if iw.info_window.position.nil? or iw.info_window.size.nil?
        xp = 50
        xpw = game.window.width-50
        yp = 50
        ypw = game.window.height-50
        dp = 10

      else
        xp = iw.info_window.position[0]
        xpw = xp + iw.info_window.size[0]
        yp = iw.info_window.position[1]
        ypw = iw.info_window.size[1]
        dp =  10
      end
      darken_screen(game, xp, xpw, yp, ypw)
      #TODO fix this ZOrder stupidity
      iw.description.each_with_index do |desc, idx|
        game.font_controller.draw_with_font(desc, xp + dp, yp + dp*(idx + 1), ZOrder.hud.value)
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
      cp = game.camera.screen_coordinates_for(vf.current_position)
      img = game.image_controller.lookup_image(game.player_bullet)
      img.draw(cp.x,cp.y, ZOrder.dynamic.value)
    end
  end
  class TargetDamageRenderingView < BaseView
    def call(screen, tr)
      pos = game.camera.screen_coordinates_for(tr.position)
      w = tr.radius
      darken_screen(game, pos.x - w, pos.x + w, pos.y - w, pos.y + w, transparent_red, ZOrder.hud.value)
    end
  end
  class PlayerHealthRenderingView < BaseView
    def call(screen, tr)
      img = game.image_controller.lookup_image(game.player_damage_mask)
      img.draw(0,0, ZOrder.dynamic.value, 1, 1, 0xffffffff, mode = :default)
    end
  end
  class FadeInLevelRenderingView < BaseView
    def call(screen, tr)
      darken_screen(game, 0, game.screen.width, 0, game.screen.width, fade_in_color_for(tr.time_to_live.to_f/tr.start_time_to_live.to_f))
    end
  end

  class PickupItemView < BaseView
    def call(screen, item)
      pos = game.camera.screen_coordinates_for(item.position)
      game.font_controller.draw_with_font("X", pos.x, pos.y, ZOrder.dynamic.value)
    end
  end
  class TargettingRenderingView < BaseView
    def call(screen, rendering_controller)
      puts "need to render targetting"

    end
  end


  class NOOPView
    def call(screen, we)
      # NOOP
    end
  end

end

module RenderingTypes
  TARGET_DAMAGE = "RENDER_TARGET_DAMAGE"
  PLAYER_HEALTH = "RENDER_PLAYER_HEALTH"
  FADE_IN_LEVEL = "RENDER_LEVEL_FADE"
  INFO_WINDOW = "RENDER_INFO_WINDOW"
  TARGETTING = "RENDER_TARGETTING"
end

class TemporaryRendering
  attr_reader :entity, :type, :time_to_live, :start_time_to_live
  def initialize(entity, type, time_to_live)
    @entity, @type, @time_to_live = entity, type, time_to_live
    @start_time_to_live = time_to_live
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
               PickupItem => Views::PickupItemView.new(@game),
               LineOfSightQuery => Views::NOOPView.new,
               #MouseCollisionWrapper => lambda {|screen, enemy| puts "NOOP, could add a highlight?" },
               VectorFollower => Views::VectorFollowerView.new(@game),
              RenderingTypes::TARGETTING => Views::TargettingRenderingView.new(@game),
              RenderingTypes::TARGET_DAMAGE => Views::TargetDamageRenderingView.new(@game),
              RenderingTypes::PLAYER_HEALTH => Views::PlayerHealthRenderingView.new(@game),
              RenderingTypes::FADE_IN_LEVEL => Views::FadeInLevelRenderingView.new(@game),
              RenderingTypes::INFO_WINDOW => Views::InfoWindowView.new(@game),
    }

    @temporary_renderings = []
    @indeterminate_renderings = []
  end


  def matching_renderings(entity, type)
    @temporary_renderings.select{|tr| tr.entity == entity && tr.type == type}
  end

  def add_indeterminate_consumable_rendering(entity, type )
    @indeterminate_renderings << add_consumable_rendering(entity, type, 0)

  end

  def add_consumable_rendering(entity, type, duration)
    matching = matching_renderings(entity, type)
    if matching.empty?
      tr = TemporaryRendering.new(entity, type, duration)
      @temporary_renderings << tr
    else
      tr = matching.first
    end
    tr
  end

  def remove_consumable_rendering(entity, type)
    m = matching_renderings(entity, type)
    @temporary_renderings -= m
    @indeterminate_renderings -= m
  end
  def tick
    @temporary_renderings.each {|tr|tr.tick}
    @temporary_renderings.reject!{|tr| tr.dead? and !@indeterminate_renderings.include?(tr)}
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
