
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
