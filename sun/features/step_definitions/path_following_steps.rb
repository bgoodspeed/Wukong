Given /^I create the path following manager$/ do
  @path_manager = PathFollowingManager.new(@game)
  @game.path_following_manager = @path_manager
end

Given /^I add a projectile starting at (\d+),(\d+) from angle (\d+) at speed (\d+)$/ do |x, y, theta, v|
  @projectile = @path_manager.add_projectile([x.to_f, y.to_f], theta.to_f, v.to_f)
end

When /^I step the path following manager$/ do
  @path_manager.tick
end

Then /^the projectile should be at (\d+),(\d+)$/ do |x,y|
  p = @path_manager.vector_following.first

  p.current_position.should be_near([x.to_f, y.to_f])
end
Then /^there should be no projectiles$/ do
  projectiles = @path_manager.vector_following
  projectiles.should == []
end

Then /^there should be projectiles at:$/ do |table|
  projectiles = @path_manager.vector_following
  currents = projectiles.collect{|p| p.current_position}
  table.map_column!("expected_position") {|vs| to_vector(vs)}

  table.hashes.each {|hash|
    expected = hash['expected_position']

    matches = projectiles.select {|p| p.current_position.near?(expected)}
    matches.empty?.should be_false, "Could not find #{expected} in #{currents}"
  }

end
Then /^the projectile collision radius should be (\d+)$/ do |rad|
  @projectile.collision_radius.should be_near rad.to_f
end

Then /^the projectile collision center should be (\d+),(\d+)$/ do |x,y|
  @projectile.collision_center.should be_near [x.to_i, y.to_i]
end
