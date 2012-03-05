
Given /^I set the player avatar to "([^"]*)"$/ do |avatar_image|
  @player = Player.new("test-data/sprites/#{avatar_image}", @game)
  @game.set_player @player
end

Given /^I set the player step size to (\d+)$/ do |step_size|
  @player.step_size = step_size.to_i
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

  elems.size.should == 1
  elems.first.class.should == Player
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
