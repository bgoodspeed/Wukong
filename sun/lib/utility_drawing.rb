# To change this template, choose Tools | Templates
# and open the template in the editor.

module TransparencyUtils
  def transparency_color
    Gosu::Color.argb(0xffff00ff)
  end

end
module UtilityDrawing
  include TransparencyUtils
  def draw_line_segment(screen, ls, zorder = ZOrder.dynamic.value)
    screen.draw_line(ls.sx, ls.sy, Gosu::Color::BLACK,ls.ex, ls.ey, Gosu::Color::BLACK, zorder  )
  end

  def draw_animation_at(screen, position, animation)
    img = animation.image
    img.draw(position.vx - img.width/2.0, position.vy - img.height/2.0, ZOrder.dynamic.value, 1, 1, transparency_color, :add )
    
  end

  def draw_rectangle(screen, r)
    screen.draw_quad(
      r.p1.x, r.p1.y, Gosu::Color::BLACK,
      r.p2.x, r.p2.y, Gosu::Color::BLACK,
      r.p3.x, r.p3.y, Gosu::Color::BLACK,
      r.p4.x, r.p4.y, Gosu::Color::BLACK
    )
  end
end
