
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
  def initialize(game, menu_id)
    @game = game
    @menu_id = menu_id
    @entries = []
    @current_index = 0

    @x_spacing = 10
    @y_spacing = 10
    @menu_mode = false
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

  #TODO this whole menu rendering thing is a hideous mess

  def region_for_index(index)
    if image_menu?
      pos = [@x_spacing, @y_spacing ]
      x = pos[0]
      y = pos[1] * (index)
      step = pos[1]
      xs = @menu_width
      Primitives::Rectangle.new([x,y], [x,y+step], [x+xs, y+step], [x + xs, y])
    else
      pos = [@x_spacing, @y_spacing ]
      if @game.menu_mode?
        pos = pos.scale(@menu_scale)
      end
      x = pos[0]
      y = pos[1] * (index+1)
      step = pos[1]
      xs = @menu_width

      Primitives::Rectangle.new([x,y], [x,y+step], [x+xs, y+step], [x + xs, y])

    end
  end

  def draw_images
    @entries.each_with_index do |entry, index|
      @game.image_controller.lookup_image(entry.image).draw( @x_spacing, index * @y_spacing, ZOrder.dynamic.value)
    end

  end

  def draw_lines(pos)
    lines.each_with_index do |line, index|
      x = pos[0]
      y = pos[1] * (index+1)
      #TODO should use draw_with_font
      @game.font_controller.font.draw(line, x,y,ZOrder.hud.value )

    end
  end

  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    m = data['menu']
    menu = Menu.new(game, m['menu_id'])
    m['entries'].each_with_index do |entry, index|
      game.image_controller.register_image(entry['image']) if entry['image']
      menu.add_entry(MenuEntry.new(index, entry))
    end
    menu
  end

end

