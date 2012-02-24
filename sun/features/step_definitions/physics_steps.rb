When /^I ask for the static bodies$/ do
  @bodies = @level.static_bodies
end

Then /^I should have (\d+) bodies$/ do |numbodies|
  @bodies.size.should == numbodies.to_i
end
