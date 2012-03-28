Given /^I create a new menu called "([^"]*)":$/ do |name, string|
  @menu = Menu.from_yaml(string)
  @menu_manager.add_menu(name, @menu)
  
end
Given /^I create a menu manager$/ do
  @menu_manager = MenuManager.new(@game)
  @game.menu_manager = @menu_manager
end
Given /^I set the main menu name to "([^"]*)"$/ do |name|
  @game.main_menu_name = name
end

When /^I enter the menu$/ do
  @game.enter_menu
end

Then /^the menu named "([^"]*)" should be active$/ do |name|
  menu = @menu_manager.menu_named(name)

  @menu_manager.should be_active
  @menu_manager.current_menu.should == menu
end

Then /^the current menu entry should have:$/ do |table|
  me = @menu_manager.current_menu_entry
  table.hashes.each_with_index {|hash, idx|
    me.display_text.to_s.should == hash['display_text'].to_s
    me.action.to_s.should == hash['action'].to_s
    me.action_argument.to_s.should == hash['action_argument'].to_s
  }

end

When /^I move down in the menu$/ do
  @menu_manager.move_down
end
Given /^I register a fake action to return triple the argument called "([^"]*)"$/ do |name|
  @menu_manager.register_action(name, lambda {|arg| arg * 3})
end

When /^I invoke the current menu action$/ do
  @menu_result = @menu_manager.invoke_current
end

Then /^the menu action result should be (\d+)$/ do |arg1|
  @menu_result.to_s.should == arg1.to_s
end

Then /^the game should be in menu mode$/ do
  @menu_manager.should be_active
end
