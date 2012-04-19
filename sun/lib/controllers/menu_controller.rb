# To change this template, choose Tools | Templates
# and open the template in the editor.

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
