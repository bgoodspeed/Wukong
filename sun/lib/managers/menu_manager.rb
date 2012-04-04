# To change this template, choose Tools | Templates
# and open the template in the editor.

class MenuEntry
  def initialize(index, conf)
    @index = index
    @conf = conf
  end

  def display_text
    @conf['display_text']
  end
  def action
    @conf['action']
  end
  def action_argument
    @conf['action_argument']
  end
end

class Menu
  attr_reader :current_index, :menu_id, :entries
  def initialize(menu_id)
    @menu_id = menu_id
    @entries = []
    @current_index = 0
  end

  def move_down
    @current_index = (@current_index + 1) % @entries.size
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

  def self.from_yaml(yaml)
    data = YAML.load(yaml)
    m = data['menu']
    menu = Menu.new(m['menu_id'])
    m['entries'].each_with_index do |entry, index|
      menu.add_entry(MenuEntry.new(index, entry))
    end
    menu
  end

  def self.from_file(f)
    self.from_yaml(IO.readlines(f).join(""))
  end

end

class Breadcrumb
  attr_reader :menu_id, :action, :action_argument, :action_result
  def initialize(menu_id, action, action_argument, action_result)
    @menu_id, @action, @action_argument, @action_result = menu_id, action, action_argument, action_result
  end
end

class MenuManager
  attr_reader :active, :breadcrumbs



  def initialize(game)
    @game = game
    @menus = {}
    @active = false
    @active_menu_name = nil
    
    @breadcrumbs = []
  end
  def register_action(name, action)
    @game.action_manager.menu_actions[name] = action
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
    @game.action_manager.menu_actions
  end
  def do_invoke(c)
    ce = c
    action = ce.action
    action_argument = ce.action_argument
    
    m = actions[action]
    action_result = m.call(action_argument)
    menu_id = current_menu.menu_id
    @breadcrumbs << Breadcrumb.new(menu_id, action, action_argument, action_result)
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
    rs = @game.hud.highlighted_regions
    if rs.empty?
      puts "nothing to click there #{@game.input_manager.mouse_screen_coords}"
      return nil
    end
    current_menu.entries[rs.first]
  end

  def current_menu_lines
    current_menu.lines
  end
  def move_down
    current_menu.move_down
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
