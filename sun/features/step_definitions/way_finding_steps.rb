Given /^I create a new Wayfinding Layer:$/ do |yaml|
  @way_finding = WayFinding.from_yaml(yaml)
end

When /^the agent in the scene is at (\d+),(\d+)$/ do |x,y|
  @agent_position = [x.to_f, y.to_f]
end

Then /^the nearest point should be at (\d+),(\d+)$/ do |x,y|
  @way_finding.nearest_point(@agent_position).should == [x.to_f, y.to_f]
end
Then /^the best point for target (\d+),(\d+) should be at (\d+),(\d+)$/ do |tx, ty, px, py|
  p = @way_finding.best_point(@agent_position, [tx.to_f, ty.to_f])
  p.should == [px.to_f, py.to_f]
end
Then /^the best point for target (\d+),(\d+) should be undefined$/ do |tx, ty|
  p = @way_finding.best_point(@agent_position, [tx.to_f, ty.to_f])
  p.should be_nil
end
