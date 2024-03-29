
Given /^I set the player avatar to "([^"]*)"$/ do |avatar_image|

  conf = {
      'image_path' => "test-data/sprites/#{avatar_image}",
      'animation_path' => "test-data/animations/hack.png"
  }
  avatar = @game.image_controller.register_image(conf['image_path'])
  p = GVector.xy(avatar.width/2.0, avatar.height/2.0)
  radius = p.min
  position = p
  conf['radius'] = p.max
  conf['start_position'] = p
  conf['collision_primitive'] = Primitives::Circle.new(position, radius)
  @player = Player.new(@game, conf )
  @game.set_player @player
end
Given /^I load a player from "([^"]*)"$/ do |file|
  @player = YamlLoader.from_file(Player, @game, "test-data/players/#{file}")
  @game.set_player @player
end

Given /^I set the player direction to (\d+)$/ do |dir|
  the_player.direction = dir.to_i
end
Given /^I set the player step size to (\d+)$/ do |step_size|
  @player.step_size = step_size.to_i
end
Given /^I set the player menu action delay to (\d+)$/ do |arg1|
  @player.menu_action_delay = arg1.to_i
end

When /^I turn to the right (\d+) degrees$/ do |turn_sweep|
  @player.turn(turn_sweep.to_i)
end

When /^I move forward (\d+) step$/ do |steps|
  @player.move_forward(steps.to_i)
end

When /^I set the player max health to (\d+)$/ do |arg1|
  @game.player.stats.max_health = arg1.to_i
end

def numeric_direction_from_cardinal(cardinal_direction)
  known = { 'north' => 0, 'east' => 90, 'south' => 180, 'west' => 270}
  raise "Unknown cardinal direction #{cardinal_direction}" unless known.has_key?(cardinal_direction)

  known[cardinal_direction]
end

Then /^the player should be facing "([^"]*)"$/ do |cardinal_direction|
  numeric_direction = numeric_direction_from_cardinal(cardinal_direction)

  @player.direction.should == numeric_direction
end


Then /^the player should be in the scene$/ do
  elems = @game.dynamic_elements

  cs = elems.collect{|e| e.class}
  cs.should be_include(Player)
  
end
# Copyright 2012 Ben Goodspeed
class GVector
  def within_epsilon_of?(other, epsilon = 0.0005)
    rv = ((x - other.x).abs < epsilon) && ((y - other.y).abs < epsilon)

    puts "Expected #{self} to be within #{epsilon} of #{other}" unless rv

    rv
  end

end
# Copyright 2012 Ben Goodspeed
class Array
  def within_epsilon_of?(other, epsilon = 0.0005)
    self.each_with_index do |this_value, index|
      if (this_value.to_f - other[index].to_f).abs > epsilon
        puts "Expected #{self} to be within #{epsilon} of #{other}"
        return false
      end

    end
    true
  end
end

def the_player
  @player ? @player : @game.player
end

Then /^the player should be at position (\d+),(\d+)$/ do |x, y|
  expected = [x.to_i, y.to_i]
  the_player.position.should be_within_epsilon_of(GVector.xy(expected[0], expected[1]))
end


Then /^the player radius should be (\d+)$/ do |radius|
  @player.radius.should == radius.to_i
end

def p
  @player ? @player : @game.player
end

Given /^I set the player health to (\d+)$/ do |arg1|
  p.health = arg1.to_i
end

Given /^I set the enemy health to (\d+)$/ do |arg1|
  @enemy.health = arg1.to_i
end

Then /^the player health should be (\d+)$/ do |arg1|
  p.health.should == arg1.to_i
end

Then /^the enemy health should be (\d+)$/ do |arg1|
  @enemy.health.should == arg1.to_i
end
Then /^the player property "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  @game.player.send(arg1).to_s.should == arg2
end

Given /^I set the player position to (\d+),(\d+)$/ do |arg1, arg2|
  p.position = GVector.xy(arg1.to_i, arg2.to_i)
end

When /^I damage the player$/ do
  p.take_damage(SHolder.new(p.stats.dup) )
end

Then /^the player should be dead$/ do
  p.should be_dead
end

Then /^the player should have yaml:$/ do |string|
  p.to_yaml.should == string
end
Then /^the player should have yaml matching "([^"]*)"$/ do |arg1|

  yml = p.to_yaml
  expected_lines = IO.readlines("test-data/players/#{arg1}")

  expected_lines.each do|line|
    l = line.strip
    matched = yml =~ Regexp.new(l)
    matched.should be_true, "Expected #{l} to be in yml: #{yml}"

  end
end

Then /^the player inventory item filtered by "([^"]*)" should have property "([^"]*)" equal to "([^"]*)"$/ do |filter, prop, value|
  item = p.inventory.items_matching(eval(filter)).first
  invoke_property_string_on(item, prop).should == eval(value)
end

Then /^the player inventory filtered by "([^"]*)" should have size (\d+)$/ do |filter, arg2|
  p.inventory.items_matching(eval(filter)).size.should == arg2.to_i
end

When /^the player takes reward "([^"]*)"$/ do |arg1|
  item = @game.inventory_controller.item_named(arg1)
  raise "Unknown reward #{item}" unless item
  p.take_reward(item)
end

When /^the player equips the weapon "([^"]*)"$/ do |arg1|
  p.equip_weapon(@game.inventory_controller.item_named(arg1))
end

When /^the player equips the armor "([^"]*)"$/ do |arg1|
  p.equip_armor(@game.inventory_controller.item_named(arg1))
end


Then /^the player inventory armor should not be nil$/ do
  p.inventory.armor.should_not be_nil
end

Then /^the player inventory weapon should not be nil$/ do
  p.inventory.weapon.should_not be_nil
end

Then /^the player inventory yaml should match "([^"]*)"$/ do |arg1|
  p.inventory.to_yaml.should =~ Regexp.new(arg1)
end


Given /^I set the player property "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
  p.send("#{arg1}=", arg2)
end


When /^I invoke the damage action$/ do
  col = Mocha::Mock.new("mock collision")
  col.stubs(:dynamic1).returns p
  col.stubs(:dynamic2).returns p
  @game.action_controller.invoke(ResponseTypes::DAMAGING1, col)
end

Given /^I create a valid player$/ do
  conf = Player.defaults
  conf['radius'] = 9
  conf['start_position'] = GVector.xy(1,2)
  conf['collision_primitive'] = Primitives::Circle.new(conf['start_position'], conf['radius'])
  @player = Player.new(mock_game, conf)
end


Then /^the player should be valid$/ do
  @player.valid?.should be(ValidationHelper::Validation::VALID)
end
When /^I unset the player property "([^"]*)"$/ do |arg1|
  @player.send("#{arg1}=", nil)
end


Then /^the player should not be valid$/ do
  @player.valid?.should_not be(ValidationHelper::Validation::VALID)
end

When /^the player acquires the enemy inventory$/ do
  @game.player.acquire_inventory(@enemy.inventory)
end

When /^the player uses his only inventory item$/ do
  potions = @game.player.inventory.items_matching(InventoryTypes::POTION)
  potions.should_not be_empty
  potion = potions.first

  @game.player.use_item(potion)
end