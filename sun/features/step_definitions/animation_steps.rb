
Given /^I create an animation manager with a ratio of one animation tick to (\d+) game ticks$/ do |game_clock_ticks|

  @animation_manager = AnimationManager.new(@game, game_clock_ticks.to_i)
end

Given /^I set the player attack animation to "([^"]*)"$/ do |attack_animation|
  @animation_manager.load_animation(@player, "attack", "test-data/animations/#{attack_animation}")
  @game.animation_manager = @animation_manager
end

Then /^the animation index for the player attack animation should be (\d+)$/ do |idx|
  @animation_manager.animation_index_by_entity_and_name(@player, "attack").animation_index.should == idx.to_i
end
