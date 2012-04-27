
class MenuEntry
  attr_accessor :display_text, :action, :action_argument, :image
  def initialize(index, conf)
    @index = index
    @conf = conf
    @display_text, @action, @action_argument, @image = @conf['display_text'], @conf['action'], @conf['action_argument'], @conf['image']

  end

end

class Menu
  attr_reader :current_index, :menu_id, :entries
  attr_accessor :x_spacing, :y_spacing, :menu_scale, :menu_width
  def initialize(game, menu_id)
    @game = game
    @menu_id = menu_id
    @entries = []
    @current_index = 0

    @x_spacing = 10
    @y_spacing = 10
    @menu_scale = 2
    @menu_width = 300
  end

  def image_menu?
    imaged = @entries.select {|me| me.image}
    !imaged.empty?
  end

  def move_down
    @current_index = (@current_index + 1) % @entries.size
  end
  #TODO: Tung's hacking move up in menus
  def move_up
    @current_index = (@current_index - 1) % @entries.size
  end

  def current_entry
    @entries[@current_index]
  end
  def add_entry(entry)
    if entry.image
      #TODO hackish, this x/y spacing stuff should be defined in the menu entries and summed
      img = @game.image_controller.lookup_image(entry.image)
      @y_spacing = img.height
    end
    @entries << entry
  end
  def lines
    @entries.collect{|e| e.display_text}
  end
 #TODO ugly
  def cursor_position
    pos = [@x_spacing, @y_spacing ]
    pos = pos.scale(@menu_scale)
    cwi = @game.current_menu_index
    pos[1] = pos[1] * (cwi + 1)
    pos
  end
  def draw_cursor
    pos = cursor_position
    base_y = pos[1]
    @game.window.draw_triangle(pos[0] - 20, base_y - 10, Graphics::Color::WHITE,
                               pos[0] - 5,  base_y, Graphics::Color::WHITE,
                               pos[0] - 20, base_y + 10, Graphics::Color::WHITE)
  end


  def regions
    (0 .. lines.size-1).collect {|i| region_for_index(i)}
  end
  include UtilityDrawing
  include PrimitiveIntersectionTests
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
    Primitives::Rectangle.new([x,y], [x,y+step], [x+xs, y+step], [x + xs, y])
  end
  #TODO this whole menu rendering thing is a hideous mess
  def region_for_index(index)
    if image_menu?
      make_rectangle(@x_spacing , @y_spacing * (index),@y_spacing, @menu_width)
    else
      make_rectangle(@x_spacing * @menu_scale,@x_spacing*@menu_scale * (index + 1),@y_spacing*@menu_scale, @menu_width)
    end
  end

  def draw_images
    @entries.each_with_index do |entry, index|
      @game.image_controller.lookup_image(entry.image).draw( @x_spacing, index * @y_spacing, ZOrder.dynamic.value)
    end
  end



end

