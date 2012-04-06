When /^I damage the enemy$/ do
  @enemy.take_damage(nil)
end

Then /^the enemy should be dead$/ do
  @enemy.should be_dead
end

Then /^there should be a death event$/ do
  events = @game.events
  events.size.should == 1
  events.first.event_type.should == EventTypes::DEATH
end

When /^I create an enemy death event$/ do
  @game.add_event(Event.new(@enemy, EventTypes::DEATH))
end

Then /^enemy should not be in scene$/ do
  elems = @game.dynamic_elements
  enemies = elems.select{|elem| elem.kind_of? Enemy}
  enemies.should == []
end