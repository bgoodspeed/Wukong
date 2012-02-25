
Given /^I set the player avatar to "([^"]*)"$/ do |avatar_image|
  @player = Player.new("test-data/sprites/#{avatar_image}", @game.window)
  @game.player = @player
end

Then /^the player should be in the scene$/ do
  elems = @game.dynamic_elements

  elems.size.should == 1
  elems.first.class.should == Player
end

Then /^the player should be at position (\d+),(\d+)$/ do |x, y|
  @player.position.should == [x.to_i, y.to_i]
end
