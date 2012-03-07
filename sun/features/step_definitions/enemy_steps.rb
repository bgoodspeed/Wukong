Given /^I set the enemy avatar to "([^"]*)"$/ do |enemy_avatar|
  @enemy = Enemy.new("test-data/sprites/#{enemy_avatar}", @game.window)
  @game.set_enemy @enemy
end

Then /^the enemy should be in the scene$/ do
  elems = @game.dynamic_elements

  elems.size.should == 2
  elems.last.class.should == Enemy
end

#needs work here
Then /^the enemy should be at position (\d+),(\d+)$/ do |x, y|
  expected = [x.to_i, y.to_i]
  @enemy.position.should be_within_epsilon_of(expected)
end

