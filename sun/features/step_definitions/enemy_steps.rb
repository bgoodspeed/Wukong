Given /^I set the enemy avatar to "([^"]*)"$/ do |enemy_avatar|
  @enemy = Enemy.new("test-data/sprites/#{enemy_avatar}", @game)
  @game.add_enemy @enemy
end
Given /^I add an enemy from "([^"]*)"$/ do |file|
  @enemy = YamlLoader.from_file(Enemy, @game, "test-data/enemies/#{file}")
  @game.add_enemy @enemy
end

Given /^I tell the enemy to track the player$/ do
  @enemy.tracking_target = @player
end


Given /^I register the enemy in the path following controller using wayfinding$/ do
  @path_controller.add_tracking(@enemy, @way_finding)
end

Then /^the enemy should be in the scene$/ do
  elems = @game.dynamic_elements

  elems.size.should == 2
  cs = elems.collect{|e| e.class}
  cs.should be_include(Enemy)
end

def the_first_enemy
  @enemy ? @enemy : @game.level.enemies.first
end

Then /^the enemy should be at position (\d+),(\d+)$/ do |x, y|
  expected = [x.to_i, y.to_i]
  the_first_enemy.position.should be_within_epsilon_of(expected)
end


Given /^I set the enemy position (\d+),(\d+)$/ do |x, y|
  pos = [x.to_i, y.to_i]
  @enemy.position = pos
end
Then /^the enemy should be at position (\d+),(\d+)\.(\d+)$/ do |x, arg2, arg3|
  expected = [x.to_f, "#{arg2}.#{arg3}".to_f]
  the_first_enemy.position.should be_within_epsilon_of(expected)
end

Then /^the path following controller should be tracking the enemy$/ do
  @path_controller.tracking.should be_has_key(@enemy)
end


Then /^the next wayfinding point for enemy should be (\d+),(\d+)$/ do |arg1, arg2|
  expected =[arg1.to_f, arg2.to_f]
  @path_controller.tracking_point_for(@enemy).should be_within_epsilon_of(expected)
end

def check_wayfind_direction(expected)
  dir = @path_controller.current_tracking_direction_for(@enemy)
  newpos = @enemy.position.plus(dir)

  newd = newpos.distance_from(@player.position)
  dist = @enemy.position.distance_from(@player.position)

  newd.should be_< dist

  dir.should be_within_epsilon_of(expected)
end
Then /^the next wayfinding direction for enemy should be (\d+),(\d+)$/ do |arg1, arg2|
  expected =[arg1.to_f, arg2.to_f]
  check_wayfind_direction(expected)
end

Then /^the next wayfinding direction for enemy should be (\d+)\.(\d+), (\d+)\.(\d+)$/ do |arg1, arg2, arg3, arg4|
  expected = ["#{arg1}.#{arg2}".to_f,
              "#{arg3}.#{arg4}".to_f]
  check_wayfind_direction(expected)
end
Then /^the enemy should be at position (\d+)\.(\d+),(\d+)\.(\d+)$/ do |arg1, arg2, arg3, arg4|
  expected = ["#{arg1}.#{arg2}".to_f,
              "#{arg3}.#{arg4}".to_f]

  the_first_enemy.position.should be_within_epsilon_of(expected)
end

Given /^I tell the enemy velocity to (\d+)$/ do |arg1|
  @enemy.velocity = arg1.to_i
end


Then /^there should be (\d+) enemies$/ do |enemies|
  @game.enemies.size.should == enemies.to_i
end

Then /^the enemy should have (\d+) hp$/ do |arg1|
  @enemy.health.should == arg1.to_i
end

