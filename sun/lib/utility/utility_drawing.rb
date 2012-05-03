# To change this template, choose Tools | Templates
# and open the template in the editor.

module TransparencyUtils
  def transparency_color
    Graphics::Color.argb(0xffff00ff)
    #Graphics::Color.argb(0, 255, 0, 255)
  end

end
module UtilityDrawing
  include TransparencyUtils
  def draw_line_segment(screen, ls, zorder = ZOrder.dynamic.value, color=Graphics::Color::BLACK)
    screen.draw_line(ls.sx, ls.sy, Graphics::Color::BLACK, ls.ex, ls.ey, color, zorder  )
  end

  def draw_animation_at(screen, position, animation)
    img = animation.image
    img.draw(position.vx - img.width/2.0, position.vy - img.height/2.0, ZOrder.dynamic.value, 1, 1, transparency_color, :add )
  end
  def draw_animation_rotated_at(screen, position, direction, animation)
    img = animation.image
    img.draw_rot(position.vx , position.vy , ZOrder.dynamic.value, direction)
  end

  def draw_rectangle_as_box(screen, r,  zorder = ZOrder.dynamic.value, color=Graphics::Color::BLACK)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p1, r.p2), zorder, color)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p2, r.p3), zorder, color)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p3, r.p4), zorder, color)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p4, r.p1), zorder, color)
  end

  def draw_rectangle(screen, r)
    screen.draw_quad(
      r.p1.x, r.p1.y, Graphics::Color::BLACK,
      r.p2.x, r.p2.y, Graphics::Color::BLACK,
      r.p3.x, r.p3.y, Graphics::Color::BLACK,
      r.p4.x, r.p4.y, Graphics::Color::BLACK
    )
  end

  def transparent_grey
    Graphics::Color.argb(0xAA000000)
  end

  def darken_screen(g = @game, minx=0, maxx=@game.window.width, miny=0, maxy=@game.window.height)
    #TODO GOSU specific, not automatically tested
    g.window.draw_quad(
      minx,miny, transparent_grey,
      maxx,miny, transparent_grey,
      maxx,maxy, transparent_grey,
      minx,maxy, transparent_grey,
      ZOrder.dynamic.value)
  end

end
