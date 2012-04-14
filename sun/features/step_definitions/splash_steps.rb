Then /^the game should be in splash mode$/ do
  @game.splash_mode.should == true
end

Then /^the splash screen should be "([^"]*)"$/ do |arg1|
  @game.splash_controller.splash.name.should == "test-data/screens/#{arg1}"
end

Then /^the game should not be in splash mode$/ do
  @game.splash_mode.should == false
end

