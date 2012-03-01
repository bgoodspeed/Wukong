# To change this template, choose Tools | Templates
# and open the template in the editor.

module UtilityDrawing
  def draw_line_segment(screen, ls)
    screen.draw_line(ls.sx, ls.sy, Gosu::Color::BLACK,ls.ex, ls.ey, Gosu::Color::BLACK  ) #TODO ZORDER
  end
end
