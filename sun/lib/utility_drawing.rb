# To change this template, choose Tools | Templates
# and open the template in the editor.

module UtilityDrawing
  def draw_line_segment(screen, ls, zorder = ZOrder.dynamic.value)
    screen.draw_line(ls.sx, ls.sy, Gosu::Color::BLACK,ls.ex, ls.ey, Gosu::Color::BLACK, zorder  )
  end
end
