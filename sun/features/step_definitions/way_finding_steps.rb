Given /^I create a new Wayfinding Layer:$/ do |yaml|
  @way_finding = WayFindingLoader.from_yaml(@game, yaml)
end


Given /^I load wayfinding layer "([^"]*)"$/ do |layer_name|
  f = "test-data/levels/#{layer_name}/wayfinding.yml"
  f = "test-data/#{layer_name}" if layer_name =~ /\//
  @way_finding = YamlLoader.from_file(WayFinding, @game, f)

end

When /^the agent in the scene is at (\d+),(\d+)$/ do |x,y|
  @agent_position = GVector.xy(x.to_f, y.to_f)
end
When /^I set the wayfinding close enough threshold to (\d+)$/ do |arg1|
  @way_finding.close_enough_threshold= arg1.to_i
end
Then /^the nearest point should be at (\d+),(\d+)$/ do |x,y|
  np = @way_finding.nearest_point(@agent_position)
  np.should be_within_epsilon_of(GVector.xy(x.to_f,y.to_f))
end
Then /^the best point for target (\d+),(\d+) should be at (\d+),(\d+)$/ do |tx, ty, px, py|
  p = @way_finding.best_point(@agent_position, GVector.xy(tx.to_f, ty.to_f))
  p.should == GVector.xy(px.to_f, py.to_f)
end
Then /^the best point for target (\d+),(\d+) should be undefined$/ do |tx, ty|
  p = @way_finding.best_point(@agent_position, GVector.xy(tx.to_f, ty.to_f))

  

  p.should be_nil
end



Given /^I create a graph$/ do
  @graph = WayfindingGraph.new
end

Then /^the graph property "([^"]*)" should be "([^"]*)"$/ do |prop, expected|
  invoke_property_string_on(@graph, prop).should == eval(expected)
end


When /^I add a node named "([^"]*)" at position (\d+), (\d+)$/ do |name, x, y|
  @graph.add_node(name, GVector.xy(x.to_i,y.to_i))
end

When /^I add an edge from "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
  @graph.add_edge(arg1, arg2)
end

Then /^weight of edge "([^"]*)","([^"]*)" should be "([^"]*)"$/ do |arg1, arg2, arg3|
  @graph.edge_weight_for(arg1, arg2).should == eval(arg3)
end

Then /^the neighbors for "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  @graph.neighbors_for(arg1).should == eval(arg2)
end

When /^I run the A\-Star algorithm from start "([^"]*)" and goal "([^"]*)"$/ do |arg1, arg2|
  @a_star_path = @graph.a_star(arg1, arg2)
end


Then /^the A\-Star path should be "([^"]*)"$/ do |arg1|
  @a_star_path.should == eval(arg1)
end


Then /^the closest node to position (\d+), (\d+) should be "([^"]*)"$/ do |x, y, expected_name|
  @graph.closest_node_to(GVector.xy(x.to_i, y.to_i)).should == expected_name
end

Given /^I create a graph from yaml "([^"]*)"$/ do |arg1|
  @graph = YamlLoader.from_file(WayfindingGraph, mock_game, "test-data/#{arg1}")
end
