
Given /^I set the player avatar to "([^"]*)"$/ do |avatar_image|
  @player = Player.new("test-data/sprites/#{avatar_image}", @game)
  @game.set_player @player
end
Given /^I load a player from "([^"]*)"$/ do |file|
  @player = YamlLoader.from_file(Player, @game, "test-data/players/#{file}")
  @game.set_player @player
end

Given /^I set the player direction to (\d+)$/ do |dir|
  @player.direction = dir.to_i
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

Then /^the player should be at position (\d+),(\d+)$/ do |x, y|
  expected = [x.to_i, y.to_i]
  @player.position.should be_within_epsilon_of(expected)
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
  @player.health.should == arg1.to_i
end

Then /^the enemy health should be (\d+)$/ do |arg1|
  @enemy.health.should == arg1.to_i
end
Then /^the player property "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  @game.player.send(arg1).to_s.should == arg2.to_s
end

Given /^I set the player position to (\d+),(\d+)$/ do |arg1, arg2|
  p.position = [arg1.to_i, arg2.to_i]
end

When /^I damage the player$/ do
  p.take_damage(nil)
end

Then /^the player should be dead$/ do
  p.should be_dead
end

Then /^the player should have yaml:$/ do |string|
  p.to_yaml.should == string
end
Then /^the player should have yaml matching "([^"]*)"$/ do |arg1|

  yml = p.to_yaml
  expected_lines = IO.readlines("test-data/players/expected_player.yml")

  expected_lines.each do|line|
    l = line.strip
    matched = yml =~ Regexp.new(l)
    matched.should be_true, "Expected #{l} to be in yml: #{yml}"

  end
end



