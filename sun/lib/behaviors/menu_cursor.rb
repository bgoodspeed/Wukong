module MenuCursor
  #TODO ugly
  def cursor_position
    ce = current_entry
    cp = ce.position
    if cp
      tmp = GVector.xy(0,0) #NOTE temporary vector allocation
      cp.plus(tmp, GVector.xy(0, @y_spacing*@menu_scale/2.0))
      return tmp
    end
    pos = GVector.xy(@x_spacing, @y_spacing)
    tmp_s = GVector.xy(0,0) #NOTE temporary vector allocation
    pos.scale(tmp_s, @menu_scale)
    cwi = @game.current_menu_index
    tmp_s.y = tmp_s.y * (cwi + 1)
    tmp_s
  end
  def draw_cursor
    pos = cursor_position
    base_y = pos.y
    @game.window.draw_triangle(pos.x - 20, base_y - 10, Graphics::Color::WHITE,
                               pos.x - 5,  base_y, Graphics::Color::WHITE,
                               pos.x - 20, base_y + 10, Graphics::Color::WHITE, ZOrder.hud.value)
  end

  def move_down
    @current_index = (@current_index + 1) % entries.size
  end
  def move_up
    @current_index = (@current_index - 1) % entries.size
  end


end