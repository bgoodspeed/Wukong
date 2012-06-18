When /^I ask for the static bodies$/ do
  @bodies = @level.static_bodies
end

Then /^I should have (\d+) bodies$/ do |numbodies|
  @bodies.size.should == numbodies.to_i
end

When /^I increase the turret angle$/ do
  @game.level.physics.turret.increase_angle
end

When /^I decrease the turret angle$/ do
  @game.level.physics.turret.decrease_angle
end

When /^I increase the turret power$/ do
  @game.level.physics.turret.increase_power
end

When /^I decrease the turret power$/ do
  @game.level.physics.turret.decrease_power
end
When /^I fire the turret$/ do
  @game.level.physics.turret.fire
end

def expectant_space
  m = Mocha::Mock.new("chipmunk space mock")
  m.expects("gravity=")
  m.expects("damping=")
  m.expects("add_shape").at_least(4)
  m.expects("add_body").at_least(4)
  #m.stubs("add_body")
  m.expects("add_constraint")
  m.expects("add_collision_func").with(:bullet, :bullet)
  m.expects("add_collision_func").with(:bullet, :wall)
  m.expects("add_collision_func").with(:bullet, :enemy)
  m.expects("add_collision_func").with(:bullet, :base)
  m.expects("add_collision_func").with(:payload, :base)
  m.expects("add_collision_func").with(:payload, :wall)
  m.expects("add_collision_func").with(:enemy, :drop_line)
  m.expects("add_collision_func").with(:bullet, :drop_line)

  m
end
Given /^I expect calls to the physics engine$/ do
  Physics::Space.stubs(:new).returns expectant_space
end


When /^I step the physics simulation (\d+) times$/ do |n|
  n.to_i.times { @game.level.physics.update }
end

Given /^I set the turret power to (\d+)$/ do |arg1|
  @game.level.physics.turret.power = arg1.to_i
end


Given /^I set the turret angle to (\d+)$/ do |arg1|
  @game.level.physics.turret.angle = arg1.to_f
end
When /^I set the position of the first physical bullet to (\d+), (\d+)$/ do |arg1, arg2|
  @game.level.physics.bullets.first.shape.body.p.x = arg1.to_i
  @game.level.physics.bullets.first.shape.body.p.y = arg2.to_i
end

When /^I set the position of the first physical enemy to (\d+), (\d+)$/ do |arg1, arg2|
  @game.level.physics.enemies.first.shape.body.p.x = arg1.to_i
  @game.level.physics.enemies.first.shape.body.p.y = arg2.to_i
end

When /^I set the position of the physical enemy base to (\d+), (\d+)$/ do |arg1, arg2|
  @game.level.physics.enemy_base.shape.body.p.x = arg1.to_i
  @game.level.physics.enemy_base.shape.body.p.y = arg2.to_i
  end

When /^I set the position of the physical player base to (\d+), (\d+)$/ do |arg1, arg2|
  @game.level.physics.player_base.shape.body.p.x = arg1.to_i
  @game.level.physics.player_base.shape.body.p.y = arg2.to_i
end

When /^I add a payload at (\d+),(\d+) with mass (\d+)$/ do |x,y,m|
  @game.level.physics.add_payload_drop_at(x.to_i, y.to_i, m.to_i, 1, m.to_i).each {|payload| @game.level.physics.payloads_to_add << payload }

end
When /^I set the position of the second physical bullet to (\d+), (\d+)$/ do |arg1, arg2|
  @game.level.physics.bullets[1].shape.body.p.x = arg1.to_i
  @game.level.physics.bullets[1].shape.body.p.y = arg2.to_i
end