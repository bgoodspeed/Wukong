# To change this template, choose Tools | Templates
# and open the template in the editor.

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



  def region_for_index(index)
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


  def draw_lines(pos)
    lines.each_with_index do |line, index|
      x = pos[0]
      y = pos[1] * (index+1)
      #TODO should use draw_with_font
      @game.font_controller.font.draw(line, x,y,ZOrder.hud.value )

    end
  end

  def self.from_yaml(game, yaml)
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

class Breadcrumb
  attr_reader :menu_id, :action, :action_argument, :action_result
  def initialize(menu_id, action, action_argument, action_result)
    @menu_id, @action, @action_argument, @action_result = menu_id, action, action_argument, action_result
  end
end

class MenuController
  attr_reader :active, :breadcrumbs, :active_menu_name



  def initialize(game)
    @game = game
    @menus = {}
    @active = false
    @active_menu_name = nil
    
    @breadcrumbs = []
  end
  def register_action(name, action)
    @game.action_controller.menu_actions[name] = action
  end

  def add_menu(name, menu)
    @menus[name] = menu
  end
  def menu_named(name)
    @menus[name]
  end

  def invoke_current_mouse
    ce = current_menu_entry_mouse
    return if ce.nil?
    do_invoke(ce)
  end

  def invoke_current
    do_invoke(current_menu_entry)
  end

  def actions
    @game.action_controller.menu_actions
  end
  def do_invoke(c)
    @game.log.info { "Attempting to invoke #{c}"}
    ce = c
    action = ce.action
    action_argument = ce.action_argument
    
    m = actions[action]
    action_result = m.call(@game, action_argument)
    menu_id = current_menu.menu_id
    @breadcrumbs << Breadcrumb.new(menu_id, action, action_argument, action_result)
    @game.log.info { "Successfully invoked menu entry #{action}(#{action_argument})"}
    action_result
  end
  def current_menu_index
    current_menu.current_index
  end
  def current_menu
    menu_named @active_menu_name
  end
  def current_menu_entry
    current_menu.current_entry
  end

  def current_menu_entry_mouse
    rs = current_menu.highlighted_regions
    if rs.empty?
      @game.log.info { "nothing found in menu mouse click"}
      return nil
    end
    @game.log.info { "found #{rs.first} in menu mouse click"}
    current_menu.entries[rs.first]
  end

  def current_menu_lines
    raise "#{@active_menu_name}" unless current_menu
    current_menu.lines
  end
  def move_down
    current_menu.move_down
  end
  #TODO: Tung's hacking move up in menus
  def move_up
    current_menu.move_up
  end
  def activate(name)
    @active_menu_name = name
    @active = true
  end
  def inactivate
    @active = false
    @active_menu_name = nil
  end

  alias_method :active?, :active
end
