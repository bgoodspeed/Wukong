module MenuMouse
  include PrimitiveIntersectionTests

  def regions
    (0 .. lines.size-1).collect {|i| region_for_index(i)}
  end

  def highlighted_regions
    msc = @game.input_controller.mouse_screen_coords
    rv = []
    regions.each_with_index {|r, idx| rv << idx if rectangle_point_intersection?(r, msc) }
    rv
  end

  def highlight_mouse_selection
    rs = regions
    regs = highlighted_regions.collect {|hridx| rs[hridx]}
    regs.each {|rect|  draw_rectangle_as_box(@game.screen, rect, ZOrder.hud.value, Graphics::Color::GREEN) }
  end

  def make_rectangle(x,y,step, xs)
    Primitives::Rectangle.new(GVector.xy(x,y), GVector.xy(x,y+step), GVector.xy(x+xs, y+step), GVector.xy(x + xs, y))
  end
  #TODO this whole menu rendering thing is a hideous mess
  def region_for_index(index)
    if image_menu?
      make_rectangle(@x_spacing , @y_spacing * (index),@y_spacing, @menu_width)
    else
      pos = entries[index].position
      if pos
        make_rectangle(pos.x, pos.y, @y_spacing * @menu_scale, @menu_width)
      else
        make_rectangle(@x_spacing * @menu_scale,@x_spacing*@menu_scale * (index + 1),@y_spacing*@menu_scale, @menu_width)
      end

    end
  end

end