When /^I enter targetting mode$/ do
  @game.targetting_controller.active = true
end

Given /^I create an odds calculator$/ do
  @odds_calculator = HitOddsCalculator.new
end

Then /^the hit odds for distance (\d+) with distance threshold (\d+) should be (\d+)%$/ do |distance, dt, expected|
  @odds_calculator.odds_for_distance_and_threshold(distance.to_i, dt.to_i).to_f.should be_near(expected.to_f)
end
