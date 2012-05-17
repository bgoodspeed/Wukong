Given /^I create a new Wayfinding Layer:$/ do |yaml|
  @way_finding = WayFinding.from_yaml(@game, yaml)
end
Given /^I load wayfinding layer "([^"]*)"$/ do |layer_name|
  @way_finding = YamlLoader.from_file(WayFinding, @game, "test-data/levels/#{layer_name}/wayfinding.yml")

end

When /^the agent in the scene is at (\d+),(\d+)$/ do |x,y|
  @agent_position = GVector.xy(x.to_f, y.to_f)
end

Then /^the nearest point should be at (\d+),(\d+)$/ do |x,y|
  "#{@way_finding.nearest_point(@agent_position)}".should == GVector.xy(x,y).to_s

end
Then /^the best point for target (\d+),(\d+) should be at (\d+),(\d+)$/ do |tx, ty, px, py|
  p = @way_finding.best_point(@agent_position, GVector.xy(tx.to_f, ty.to_f))
  p.should == GVector.xy(px.to_f, py.to_f)
end
Then /^the best point for target (\d+),(\d+) should be undefined$/ do |tx, ty|
  p = @way_finding.best_point(@agent_position, GVector.xy(tx.to_f, ty.to_f))

  

  p.should be_nil
end
