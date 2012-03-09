Given /^I set the enemy avatar to "([^"]*)"$/ do |enemy_avatar|
  @enemy = Enemy.new("test-data/sprites/#{enemy_avatar}", @game)
  @game.set_enemy @enemy
end

Then /^the enemy should be in the scene$/ do
  elems = @game.dynamic_elements

  elems.size.should == 2
  elems.last.class.should == Enemy
end



Then /^the enemy should be at position (\d+),(\d+)$/ do |x, y|
  expected = [x.to_i, y.to_i]
  @enemy.position.should be_within_epsilon_of(expected)
end


Given /^I set the enemy position (\d+),(\d+)$/ do |x, y|
  pos = [x.to_i, y.to_i]
  @enemy.position = pos
end
Then /^the enemy should be at position (\d+),(\d+)\.(\d+)$/ do |x, arg2, arg3|
  expected = [x.to_f, "#{arg2}.#{arg3}".to_f]
  @enemy.position.should be_within_epsilon_of(expected)
end
