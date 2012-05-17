Given /^I load the main menu "([^"]*)"$/ do |filename|
  @menu = YamlLoader.from_file(Menu, @game, "test-data/menus/#{filename}")
  @menu_controller.add_menu(@game.main_menu_name, @menu)
end


Given /^I create a new menu called "([^"]*)":$/ do |name, string|

  @menu = Menu.from_yaml(@game, string)
  @menu_controller.add_menu(name, @menu)
  
end

Given /^I create a menu controller$/ do
  @menu_controller = MenuController.new(@game)
  @game.menu_controller = @menu_controller
end
Given /^I set the main menu name to "([^"]*)"$/ do |name|
  @game.main_menu_name = name
end

When /^I enter the menu$/ do
  @game.enter_menu
end

Then /^the menu named "([^"]*)" should be active$/ do |name|
  menu = mm.menu_named(name)

  @menu_controller.should be_active
  @menu_controller.current_menu.should == menu
end

def mm
  @menu_controller ? @menu_controller : @game.menu_controller
end

Then /^the current menu entry should have:$/ do |table|
  me = mm.current_menu_entry
  table.hashes.each_with_index {|hash, idx|
    me.display_text.to_s.should == hash['display_text'].to_s
    me.action.to_s.should == hash['action'].to_s if hash.has_key?('action')
    me.action_argument.to_s.should == hash['action_argument'].to_s if hash.has_key?('action_argument')
    if hash.has_key?('argument')
      me.argument.to_s.should == hash['argument'].to_s
    end
    if hash.has_key?('formatted_display_text')
      me.formatted_display_text.to_s.should == hash['formatted_display_text'].to_s
    end
  }

end

Then /^the current mouse menu entry should be nil$/ do
  mm.current_menu_entry_mouse.should be_nil
end



Then /^the current mouse menu entry should have:$/ do |table|
  me = mm.current_menu_entry_mouse
  
  table.hashes.each_with_index {|hash, idx|
    me.display_text.to_s.should == hash['display_text'].to_s
    me.action.to_s.should == hash['action'].to_s if hash.has_key?('action')
    me.action_argument.to_s.should == hash['action_argument'].to_s if hash.has_key?('action_argument')
    me.argument.to_s.should == hash['argument'].to_s if hash.has_key?('argument')
  }
end
Then /^I move up in the menu$/ do
  mm.move_up
end

When /^I move down in the menu$/ do
  mm.move_down
end
Given /^I register a fake action to return triple the argument called "([^"]*)"$/ do |name|
  mm.register_action(name, lambda {|game, arg| arg * 3})
end

When /^I invoke the current menu action$/ do
  @menu_result = mm.invoke_current
end

Then /^the menu action result should be (\d+)$/ do |arg1|
  @menu_result.to_s.should == arg1.to_s
end

Then /^the game should be in menu mode$/ do
  mm.should be_active
end
Then /^the game should not be in menu mode$/ do
  mm.should_not be_active
end

Then /^the breadcrumb trail should have the following:$/ do |table|
  trail = @menu_controller.breadcrumbs

  table.hashes.each_with_index {|hash, idx|
    
    trail[idx].menu_id.should == hash['menu_id']
    trail[idx].action.should == hash['action']
    trail[idx].action_argument.to_s.should == hash['action_argument']
    trail[idx].action_result.to_s.should == hash['action_result']
  }
  
end

When /^I enter the menu "([^"]*)" with filter "([^"]*)"$/ do |menu, filter|
  @game.enter_menu(menu, eval(filter))
end

Then /^the menu's "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  mm.current_menu.send(arg1).should == eval(arg2)
end

Then /^the cursor position should be near (\d+),(\d+)$/ do |arg1, arg2|
  mm.current_menu.cursor_position.should be_within_epsilon_of(GVector.xy(arg1.to_f, arg2.to_f))
end
