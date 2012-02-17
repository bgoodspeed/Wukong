# To change this template, choose Tools | Templates
# and open the template in the editor.

Given /^I load the level "([^"]*)"$/ do |level_to_load|
  @level_loader = LevelLoader.new
  @level = @level_loader.load_level("test-data/levels/#{level_to_load}/#{level_to_load}.yml")
end

When /^the level is examined$/ do
  # NOOP
end

Then /^the level should measure (\d+), (\d+)$/ do |w, h|
  @level.measurements.should == [w.to_i, h.to_i]
end

Then /^there should be (\d+) line segments$/ do |how_many|
  @level.line_segments.size.should == how_many.to_i
end

Then /^there should be (\d+) triangles$/ do |how_many|
  @level.triangles.size.should == how_many.to_i
end

Then /^there should be (\d+) circles$/ do |how_many|
  @level.circles.size.should == how_many.to_i
end

Then /^there should be (\d+) rectangles$/ do |how_many|
  @level.rectangles.size.should == how_many.to_i
end
