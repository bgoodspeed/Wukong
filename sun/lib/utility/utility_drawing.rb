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

    img.draw(position.x - img.width/2.0, position.y - img.height/2.0, ZOrder.dynamic.value, 1, 1, transparency_color, :add )
  end
  def draw_animation_rotated_at(screen, position, direction, animation)
    img = animation.image
    img.draw_rot(position.x, position.y  , ZOrder.dynamic.value, direction)
  end
  def draw_animation_rotated_faded_at (screen, position, direction, animation, fade_in_percent)
    img = animation.image
    color = fade_in_color_for(fade_in_percent, 255, 0,0)
    img.draw_rot(position.x, position.y  , ZOrder.dynamic.value, direction, 0.5, 0.5, 1, 1, color, :add)
  end

  def draw_rectangle_as_box(screen, r,  zorder = ZOrder.dynamic.value, color=Graphics::Color::BLACK)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p1, r.p2), zorder, color)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p2, r.p3), zorder, color)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p3, r.p4), zorder, color)
    draw_line_segment(screen, Primitives::LineSegment.new(r.p4, r.p1), zorder, color)
  end

  def draw_rectangle(screen, r, c=Graphics::Color::BLACK, zo=ZOrder.dynamic.value )
    screen.draw_quad(
      r.p1.x, r.p1.y, c,
      r.p2.x, r.p2.y, c,
      r.p3.x, r.p3.y, c,
      r.p4.x, r.p4.y, c,
      zo
    )
  end

  def transparent_grey
    Graphics::Color.argb(0xCC000000)
  end
  def transparent_red
    Graphics::Color.argb(0x22FF0000)
  end
  def transparent_yellow
    Graphics::Color.argb(0x22cdcb15)
  end
  def opaque_yellow
    Graphics::Color.argb(0xEEcdcb15)
  end

  def transparent_red_near_death
    Graphics::Color.argb(0x22FF0000)
  end

  def fade_in_color_for(ratio, r=0, g=0, b=255)
    n = (ratio * (0xFF).to_f).to_i
    Graphics::Color.argb(n, r,g,b)
  end
  def darken_screen(g = @game, minx=0, maxx=@game.window.width, miny=0, maxy=@game.window.height, color=transparent_grey, zo=ZOrder.dynamic.value)
    #TODO GOSU specific, not automatically tested
    g.window.draw_quad(
      minx,miny, color,
      maxx,miny, color,
      maxx,maxy, color,
      minx,maxy, color,
      zo)
  end

end
