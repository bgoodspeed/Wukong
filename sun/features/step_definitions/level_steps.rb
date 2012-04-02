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

Then /^the minimum x is (\d+)$/ do |arg1|
  @level.minimum_x.should == arg1.to_i
end

Then /^the maximum x is (\d+)$/ do |arg1|
  @level.maximum_x.should == arg1.to_i
end

Then /^the minimum y is (\d+)$/ do |arg1|
  @level.minimum_y.should == arg1.to_i 
end

Then /^the maximum y is (\d+)$/ do |arg1|
  @level.maximum_y.should == arg1.to_i
end

Then /^the minimum x is \-(\d+)$/ do |arg1|
  @level.minimum_x.should == arg1.to_i * -1
end

Then /^the minimum y is \-(\d+)$/ do |arg1|
  @level.minimum_y.should == arg1.to_i * -1
end

Then /^the background image is named "([^"]*)"$/ do |image_name|
  @level.background_image.should =~ /#{image_name}/
end

Then /^there should be (\d+) event emitter$/ do |emitters|
  @level.event_emitters.size.should == emitters.to_i
end

Then /^the event emitters are:$/ do |table|
  emitters = @level.event_emitters
  table.map_column!("position") {|vs| to_vector(vs)}
  table.map_column!("radius") {|vs| vs.to_i}
  table.hashes.each_with_index {|hash, idx|
    emitters[idx].event_name.should == hash['event_name']
    emitters[idx].event_argument.should == hash['event_argument']
    emitters[idx].position.should == hash['position']
    emitters[idx].radius.should == hash['radius']
  }
end

Then /^wayfinding should not be nil$/ do
  @game.wayfinding.should_not be_nil
end

Then /^there should be be (\d+) enemies defined$/ do |arg1|
  @level.declared_enemies.size.should == arg1.to_i
end

#TODO maybe make spawn_points_steps.rb and move the spawn stuff there
Then /^there should be (\d+) spawn points$/ do |arg1|
  @level.spawn_points.size.should == arg1.to_i
end

Then /^the spawn points should be:$/ do |table|
  points = @level.spawn_points
  table.map_column!("point") {|vs| to_vector(vs)}
  table.map_column!("spawn_argument") {|vs|
    r = vs.split(",")
    r.collect{|e| e.strip}
    }
  table.hashes.each_with_index {|hash, idx|
    points[idx].point.should == hash['point']
    points[idx].name.should == hash['name']
    points[idx].spawn_schedule.should == hash['spawn_schedule']
    points[idx].spawn_argument.should == [hash['spawn_argument']].flatten
    points[idx].enemy_quantity.to_s.should == hash['enemy_quantity'] if hash.has_key?('enemy_quantity')
    points[idx].frequency.to_s.should == hash['frequency'] if hash.has_key?('frequency')
    points[idx].total_time.to_s.should == hash['total_time'] if hash.has_key?('total_time')
    points[idx].condition.to_s.should == hash['condition'] if hash.has_key?('condition')

  }
  
end
When /^the spawn points are updated$/ do
  @level.update_spawn_points
end
