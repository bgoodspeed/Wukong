When /^I enter targetting mode$/ do
  @game.targetting_controller.active = true
end


When /^I move to the next lower target$/ do
  @game.targetting_controller.move_to_next_lower
end
When /^I move to the next higher target$/ do
  @game.targetting_controller.move_to_next_higher
end
Given /^I create an odds calculator$/ do
  @odds_calculator = HitOddsCalculator.new
end

Then /^the hit odds for distance (\d+) with distance threshold (\d+) should be (\d+)%$/ do |distance, dt, expected|
  @odds_calculator.odds_for_distance_and_threshold(distance.to_i, dt.to_i).to_f.should be_near(expected.to_f)
end


When /^I set the player max energy points to (\d+)$/ do |arg1|
  @game.player.max_energy_points = arg1.to_i
end

When /^I set the player energy points to (\d+)$/ do |arg1|
  @game.player.energy_points = arg1.to_i
end

When /^I queue an attack on the current target$/ do
  @game.targetting_controller.queue_attack_on_current
end

When /^I invoke the current attack queue$/ do
  @game.targetting_controller.invoke_action_queue
end

When /^I stub hit odds for all targets to be (\d+) percent$/ do |arg1|
  HitOddsCalculator.any_instance.stubs(:odds_for_distance_and_threshold).returns arg1.to_i
end