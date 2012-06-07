Given /^I create a spatial hash with cell size (\d+)$/ do |cell_size|
  @spatial_hash = SpatialHash.new(cell_size.to_i)
end

When /^I override the table size to (\d+)$/ do |arg1|
  @spatial_hash.base_table_size = arg1.to_i
end

When /^I override the x prime to (\d+)$/ do |arg1|
  @spatial_hash.x_prime = arg1.to_i
end

When /^I override the y prime to (\d+)$/ do |arg1|
  @spatial_hash.y_prime = arg1.to_i
end
# Copyright 2012 Ben Goodspeed
class FakeCollisionParticipant
  attr_accessor :user_data, :prim

  def collision_type; prim.collision_type; end
  def to_collision; prim; end
  def p1; prim.p1; end
  def p2; prim.p2; end
  def p3; prim.p3; end
  def p4; prim.p4; end
end

When /^I add data "([^"]*)" at \((\d+), (\d+)\)$/ do |data, x, y|
  circle = Primitives::Circle.new(GVector.xy(x.to_i, y.to_i), 1)
  fcp = FakeCollisionParticipant.new
  fcp.prim = circle
  fcp.user_data = data
  @spatial_hash.insert_data_at(fcp, GVector.xy(x.to_i, y.to_i))
end

When /^I clear the spatial hash$/ do
  @spatial_hash.clear
end



Then /^the cell coordinate for vertex (\d+),(\d+) is (\d+),(\d+)$/ do |vx, vy, i, j|
  rvx = @spatial_hash.cell_x_index_for(vx.to_i, @spatial_hash.cell_size)
  rvy = @spatial_hash.cell_y_index_for(vy.to_i, @spatial_hash.cell_size)
  rvx.should be_near(i.to_f)
  rvy.should be_near(j.to_f)
end


Then /^the hash for (\d+),(\d+) should be (\d+)$/ do |i,j,hash|
  rv = @spatial_hash.spatial_hash(i.to_i, j.to_i, @spatial_hash.x_prime, @spatial_hash.y_prime, @spatial_hash.base_table_size)
  rv.should == hash.to_i
end

Then /^the data array looks like:$/ do |table|

  data = table.rows_hash
  data.each {|k,v|
    next unless k =~ /\d+/
    vs = @spatial_hash.data[k.to_i] #TODO reconsider this design
    if vs.nil?
      rv = ""
    else
      rvs = vs.collect{|v| v.user_data}
      rv = rvs.join(",")
    end
    
    rv.should == v
  }
  
end

Then /^asking for collision candidates yields:$/ do |table|
  table.map_column!('center_x') {|a| a.to_i}
  table.map_column!('center_y') {|a| a.to_i}
  table.map_column!('radius') {|a| a.to_i}
  table.hashes.each do |h|
    datas = @spatial_hash.candidates(h['radius'], GVector.xy(h['center_x'], h['center_y']))
    datas.flatten!
    data = datas.collect {|d| (d.kind_of?(String) or d.kind_of?(Symbol)) ? d.to_s : d.user_data }

    
    data.join(",").should == h['candidate_data']
  end
end

Then /^asking for collision pairs yields:$/ do |table|
  table.map_column!('center_x') {|a| a.to_i}
  table.map_column!('center_y') {|a| a.to_i}
  table.map_column!('radius') {|a| a.to_i}
  table.hashes.each do |h|
    pos = GVector.xy(h['center_x'], h['center_y'])
    r = h['radius']
    p = Mocha::Mock.new("player")
    p.stubs(:collision_type).returns "Circle"
    p.stubs(:collision_response_type).returns "Player"
    p.stubs(:collision_radius).returns r
    p.stubs(:collision_center).returns pos
    p.stubs(:to_collision).returns Primitives::Circle.new(pos, r)
    data_objs = @spatial_hash.dynamic_collisions([p] ) 
    data = data_objs.collect {|data_obj| data_obj.last.user_data}
    data.join(",").should == h['candidate_data']
  end
end

When /^I add line segment (\d+),(\d+):(\d+),(\d+) with data "([^"]*)"$/ do |lssx, lssy, lsex, lsey, data|
  ls = Primitives::LineSegment.new(GVector.xy(lssx.to_f, lssy.to_f), GVector.xy(lsex.to_f, lsey.to_f))
  fcp = FakeCollisionParticipant.new
  fcp.prim = ls
  fcp.user_data = data
  @spatial_hash_indices = @spatial_hash.add_line_segment(fcp, fcp)
end

Then /^the effected spatial hash indices are: "([^"]*)"$/ do |arg1|
  @spatial_hash_indices.sort.should == eval(arg1).sort
end

Given /^I create a line segment (\d+),(\d+):(\d+),(\d+)$/ do |lssx, lssy, lsex, lsey|
  @ls = Primitives::LineSegment.new(GVector.xy(lssx.to_f, lssy.to_f), GVector.xy(lsex.to_f, lsey.to_f))
end


Then /^the line segment property "([^"]*)" should be "([^"]*)"$/ do |prop, expected|
  "#{invoke_property_string_on(@ls, prop)}".should == expected
end
