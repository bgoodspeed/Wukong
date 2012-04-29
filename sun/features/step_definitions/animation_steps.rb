
Given /^I create an animation controller with a ratio of one animation tick to (\d+) game ticks$/ do |game_clock_ticks|

  @animation_controller = AnimationController.new(@game, game_clock_ticks.to_i)
  @game.animation_controller = @animation_controller
end

Given /^I set the player attack animation to "([^"]*)"$/ do |attack_animation|
  @animation_controller.load_animation(@player, "attack", "test-data/animations/#{attack_animation}")
  
end

Then /^the animation index for the player attack animation should be (\d+)$/ do |idx|
  @animation_controller.animation_index_by_entity_and_name(@player, "attack").animation_index.should == idx.to_i
end

Then /^the animation position for player "([^"]*)" should be (\d+), (\d+)$/ do |player_prop, x, y|
  @game.animation_controller.position_for(@game.player, player_prop).should be_within_epsilon_of([x.to_f, y.to_f])
end

Then /^the player attack animation should be active$/ do
  @animation_controller.animation_index_by_entity_and_name(@player, "attack").active.should == true
end

When /^I stop the player animation$/ do
  @animation_controller.stop_animation(@player, "attack")
end

When /^the player attack animation should not be active$/ do
  @animation_controller.animation_index_by_entity_and_name(@player, "attack").active.should == false
end

