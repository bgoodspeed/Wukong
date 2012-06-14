# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class Breadcrumb
  attr_reader :menu_id, :action, :action_argument, :action_result
  def initialize(menu_id, action, action_argument, action_result)
    @menu_id, @action, @action_argument, @action_result = menu_id, action, action_argument, action_result
  end
end
# Copyright 2012 Ben Goodspeed
module GameMenu
  EQUIPMENT = "equipment"
  ITEMS = "items"
end

class ActionableMenuItem
  attr_reader :action, :item, :index
  def initialize(item, index, action)
    @item = item
    @index = index
    @action = action

  end

  def position
    nil
  end
  def image
    nil
  end
  def display_text
    @item.display_name
  end

  def action_argument
    self
  end

  def argument
    @item.orig_filename
  end

  def to_s
    "#{@item.class}:#{@item.display_name}"
  end
end


# Copyright 2012 Ben Goodspeed
class ItemsMenu
  attr_accessor :filter, :current_index, :menu_id, :headers
  ATTRIBUTES = [:x_spacing, :y_spacing, :menu_scale, :menu_width, :header_text, :header_position]
  ATTRIBUTES.each {|attr| attr_accessor attr}

  include MenuCursor
  include MenuPositioned
  include MenuImages

  def initialize(game)
    @game = game
    @filter = nil
    @current_index = 0
    @menu_id = "Equipment Menu"
    @x_spacing = 10
    @y_spacing = 10
    @menu_scale = 2
    @menu_width = 300
    @headers = []
  end


  def current_entry
    lines[@current_index]
  end
  def lines
    items = @game.player.inventory.items_matching(@filter)
    menu_items = []
    items.each_with_index {|item, index| menu_items << ActionableMenuItem.new(item, index, BehaviorTypes::CONSUME_ITEM) }
    menu_items
  end
  alias_method :entries, :lines

end# Copyright 2012 Ben Goodspeed
class EquipmentMenu

  attr_accessor :filter, :current_index, :menu_id, :headers
  ATTRIBUTES = [:x_spacing, :y_spacing, :menu_scale, :menu_width, :header_text, :header_position]
  ATTRIBUTES.each {|attr| attr_accessor attr}

  include MenuCursor
  include MenuPositioned
  include MenuImages

  def initialize(game)
    @game = game
    @filter = nil
    @current_index = 0
    @menu_id = "Equipment Menu"
    @x_spacing = 10
    @y_spacing = 10
    @menu_scale = 2
    @menu_width = 300
    @headers = []
  end


  def current_entry
    lines[@current_index]
  end
  def lines
    items = @game.player.inventory.items_matching(@filter)
    menu_items = []
    items.each_with_index {|item, index| menu_items << ActionableMenuItem.new(item, index, BehaviorTypes::EQUIP_ITEM) }
    menu_items
  end
  alias_method :entries, :lines
end
# Copyright 2012 Ben Goodspeed
class MenuController
  attr_reader :active, :breadcrumbs, :active_menu_name

  include UtilityDrawing

  def initialize(game)
    @game = game
    @menus = {
      GameMenu::EQUIPMENT => EquipmentMenu.new(@game),
      GameMenu::ITEMS => ItemsMenu.new(@game)
    }
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
    @game.action_controller.menu_invoke(current_menu, ce, @breadcrumbs)
  end

  def invoke_current
    @game.action_controller.menu_invoke(current_menu, current_menu_entry, @breadcrumbs)
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

  def move_up
    current_menu.move_up
  end
  def activate(name, filter=nil)

    @active_menu_name = name
    cm =  current_menu
    if !cm
      @active_menu_name = nil
      return false
    end
    ls = cm.lines
    if ls.empty?
      @active_menu_name = nil
      return false
    end
    if !filter.nil?
      current_menu.filter = filter
    end

    @active = true
    true
  end
  def inactivate
    @active = false
    @active_menu_name = nil
  end

  #TODO this should call a menu view in rendering controller
  def draw(screen)
    darken_screen

    menu = current_menu
    menu.draw_cursor
    menu.highlight_mouse_selection if @game.input_controller.mouse_on_screen
    menu.headers.each do |header|
      @game.font_controller.draw_with_font(header.header_text, header.header_position.x, header.header_position.y, ZOrder.hud.value)
    end

    if menu.image_menu?
      menu.draw_images
    else
      if menu.positioned?
        menu.entries.each {|me| @game.font_controller.draw_with_font(me.formatted_display_text, me.position.x, me.position.y, ZOrder.hud.value  )}
      else
        tmp = GVector.xy(0,0) #NOTE temporary vector allocation
        GVector.xy(menu.x_spacing, menu.y_spacing).scale(tmp, menu.menu_scale)
        @game.font_controller.draw_lines(tmp, menu.lines)
      end

    end
  end

  alias_method :active?, :active
end
