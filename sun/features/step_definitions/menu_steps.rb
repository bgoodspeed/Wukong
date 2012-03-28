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
    me.display_text.should == hash['display_text']
    me.action.should == hash['action']
  }

end

