Given /^I create the path following manager$/ do
  @path_manager = PathFollowingManager.new(@game)
end

Given /^I add a projectile starting at (\d+),(\d+) from angle (\d+) at speed (\d+)$/ do |x, y, theta, v|
  @path_manager.add_projectile([x.to_f, y.to_f], theta.to_f, v.to_f)
end

When /^I step the path following manager$/ do
  @path_manager.tick
end

Then /^the projectile should be at (\d+),(\d+)$/ do |x,y|
  p = @path_manager.vector_following.first

  p.current_position.should be_near([x.to_f, y.to_f])
end

Then /^there should be projectiles at:$/ do |table|
  projectiles = @path_manager.vector_following
  table.map_column!("expected_position") {|vs| to_vector(vs)}
  table.hashes.each {|hash|
    expected = hash['expected_position']

    matches = projectiles.select {|p| p.current_position.near?(expected)}
    matches.empty?.should be_false
  }

end
