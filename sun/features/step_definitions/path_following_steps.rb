Given /^I create the path following controller$/ do
  @path_controller = PathFollowingController.new(@game)
  @game.path_following_controller = @path_controller
end

Given /^I add a projectile starting at (\d+),(\d+) from angle (\d+) at speed (\d+)$/ do |x, y, theta, v|
  @projectile = @path_controller.add_projectile([x.to_f, y.to_f], theta.to_f, v.to_f)
end

When /^I step the path following controller$/ do
  @path_controller.tick
end
When /^I step the path following controller (\d+) times$/ do |arg1|
  arg1.to_i.times { @path_controller.tick }
end

Then /^the projectile should be at (\d+),(\d+)$/ do |x,y|
  p = @path_controller.vector_following.first

  p.current_position.should be_near([x.to_f, y.to_f])
end
Then /^there should be no projectiles$/ do
  pm = @path_controller ? @path_controller : @game.path_following_controller
  projectiles = pm.vector_following
  
  projectiles.should == []
end

Then /^there should be projectiles at:$/ do |table|
  projectiles = @path_controller.vector_following
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
