# To change this template, choose Tools | Templates
# and open the template in the editor.

class RenderingController

  def initialize(game)
    @game = game
    @mapping = {Primitives::LineSegment => lambda {|screen, linesegment|
                 p1 = @game.camera.screen_coordinates_for(linesegment.p1)
                 p2 = @game.camera.screen_coordinates_for(linesegment.p2)
                 ls = Primitives::LineSegment.new(p1, p2)
                 draw_line_segment(screen, ls, ZOrder.static.value, Graphics::Color::RED)
               },
               Player => lambda {|screen, player| @game.image_controller.draw_in_screen_coords(player) },
               Enemy => lambda {|screen, enemy| @game.image_controller.draw_in_screen_coords(enemy) },
               EventArea => lambda {|screen, ea|
                 r = ea.rect
                 rect = Primitives::Rectangle.new(@game.camera.screen_coordinates_for(r.p1), @game.camera.screen_coordinates_for(r.p2), @game.camera.screen_coordinates_for(r.p3), @game.camera.screen_coordinates_for(r.p4))
                 #TODO this is getting messy
                 msg_offset = [15,15]
                 @game.hud.draw_with_font(ea.label, rect.p1.x + msg_offset.x, rect.p1.y + msg_offset.y, ZOrder.hud.value)
                 draw_rectangle_as_box(screen, rect,  ZOrder.static.value, color=Graphics::Color::BLACK)
#                 puts "draw event area at #{ea.rect}, with text #{ea.label} inside"
               },
               Weapon => lambda {|screen, weapon| "NOOP weapon #TODO"},
               #MouseCollisionWrapper => lambda {|screen, enemy| puts "NOOP, could add a highlight?" },
               #TODO ugly, should this be here? not sure about design
               VectorFollower => lambda {|screen, vf|
                 d = 10
                 cp = @game.camera.screen_coordinates_for(vf.current_position)

                 draw_rectangle(screen, Primitives::Rectangle.new(cp, cp.plus([d,0]), cp.plus([d,d]), cp.plus([0,d])))}
    }
    
  end

    include UtilityDrawing
  def draw_function_for(elem)
    #TODO move all drawing logic out of models in case we replace gosu
    raise "Unknown draw function for #{elem.class}" unless @mapping.has_key?(elem.class)
    @mapping[elem.class]
  end

end