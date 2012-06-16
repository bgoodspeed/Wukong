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

  m
end
Given /^I expect calls to the physics engine$/ do
  Physics::Space.stubs(:new).returns expectant_space
end