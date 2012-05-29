Given /^I set the enemy avatar to "([^"]*)"$/ do |enemy_avatar|
  conf = { 'image_path' => "test-data/sprites/#{enemy_avatar}"}
  @enemy = Enemy.new(@game, conf )
  @game.add_enemy @enemy
end
Given /^I add an enemy from "([^"]*)"$/ do |file|
  @enemy = YamlLoader.from_file(Enemy, @game, "test-data/enemies/#{file}")
  @game.add_enemy @enemy
end

Given /^I tell the enemy to track the player$/ do
  p = @player ? @player : @game.player

  @enemy.tracking_target = p
end


Given /^I register the enemy in the path following controller using wayfinding$/ do
  pc = @path_controller ? @path_controller : @game.path_following_controller
  wf = @way_finding ? @way_finding : @game.wayfinding
  pc.add_tracking(@enemy, wf )
end

Then /^the enemy should be in the scene$/ do
  elems = @game.dynamic_elements

  cs = elems.collect{|e| e.class}
  cs.should be_include(Enemy)
end

def the_first_enemy
  @enemy ? @enemy : @game.level.enemies.first
end

Then /^the enemy should be at position (\d+),(\d+)$/ do |x, y|
  the_first_enemy.position.should be_within_epsilon_of(GVector.xy(x.to_i, y.to_i))
end


Given /^I set the enemy position (\d+),(\d+)$/ do |x, y|
  @enemy.position = GVector.xy(x.to_i, y.to_i)
end
Then /^the enemy should be at position (\d+),(\d+)\.(\d+)$/ do |x, arg2, arg3|
  expected = GVector.xy(x.to_f, "#{arg2}.#{arg3}".to_f)
  the_first_enemy.position.should be_within_epsilon_of(expected)
end

Then /^the path following controller should be tracking the enemy$/ do
  @path_controller.tracking.should be_has_key(@enemy)
end


Then /^the next wayfinding point for enemy should be (\d+),(\d+)$/ do |arg1, arg2|
  expected = GVector.xy(arg1.to_f, arg2.to_f)
  @path_controller.tracking_point_for(@enemy).should be_within_epsilon_of(expected)
end

def check_wayfind_direction(expected)
  dir = @path_controller.current_tracking_direction_for(@enemy)
  tmp = GVector.xy(0,0) #NOTE temporary vector allocation
  @enemy.position.plus(tmp, dir)
  newpos = tmp

  newd = newpos.distance_from(@player.position)
  dist = @enemy.position.distance_from(@player.position)

  newd.should be_< dist

  dir.should be_within_epsilon_of(expected)
end
Then /^the next wayfinding direction for enemy should be (\d+),(\d+)$/ do |arg1, arg2|
  expected = GVector.xy(arg1.to_f, arg2.to_f)
  check_wayfind_direction(expected)
end

Then /^the next wayfinding direction for enemy should be (\d+)\.(\d+), (\d+)\.(\d+)$/ do |arg1, arg2, arg3, arg4|
  expected = ["#{arg1}.#{arg2}".to_f,
              "#{arg3}.#{arg4}".to_f]

  check_wayfind_direction(GVector.xy(expected[0], expected[1]))
end
Then /^the enemy should be at position (\d+)\.(\d+),(\d+)\.(\d+)$/ do |arg1, arg2, arg3, arg4|
  expected = ["#{arg1}.#{arg2}".to_f,
              "#{arg3}.#{arg4}".to_f]

  the_first_enemy.position.should be_within_epsilon_of(GVector.xy(expected[0], expected[1]))
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

Then /^the enemy should have hud message "([^"]*)"$/ do |arg1|
  @enemy.hud_message.should == arg1
end

Given /^I create an enemy in isolation$/ do
  @enemy = Enemy.new(mock_game, {})
end

When /^I tick tracking with vector "([^"]*)"$/ do |arg1|
  arr = eval(arg1)
  @enemy.tick_tracking(GVector.xy(arr[0], arr[1]))
end

Then /^the enemy direction should be (\d+)$/ do |arg1|
  @enemy.direction.should be_near(arg1.to_f)
end
Then /^the enemy direction should be (\d+)\.(\d+)$/ do |arg1, arg2|
  @enemy.direction.should be_near("#{arg1}.#{arg2}".to_f)
end
Then /^the animation for the enemy should not be active$/ do
  @game.animation_controller.animation_index_by_entity_and_name(the_first_enemy, the_first_enemy.animation_name).active.should == false

end


Then /^the animation for the enemy should need an update$/ do
  @game.animation_controller.animation_index_by_entity_and_name(the_first_enemy, the_first_enemy.animation_name).needs_update.should == true
end




Given /^I create a valid enemy$/ do
  @enemy = Enemy.new(mock_game, Enemy.defaults)
end


When /^I unset the enemy property "([^"]*)"$/ do |arg1|
  @enemy.send("#{arg1}=", nil)
end


Then /^the enemy should be valid$/ do
  @enemy.valid?.should be(ValidationHelper::Validation::VALID)
end
Then /^the enemy should not be valid$/ do
  @enemy.valid?.should_not be(ValidationHelper::Validation::VALID)
end

def first_enemy_named(enemy_name)
  enemies = @game.level.enemies.select {|e| e.name == enemy_name}
  enemies.should_not be_empty
  enemies.first
end

Then /^the enemy named "([^"]*)" should have "([^"]*)" equal to "([^"]*)"$/ do |enemy_name, property, value|
  first_enemy_named(enemy_name).send(property).should == eval(value)
end

And /^I set the property "([^"]*)" to "([^"]*)" on enemy named "([^"]*)"$/ do |property, value, enemy_name|
  first_enemy_named(enemy_name).send("#{property}=", eval(value))
end