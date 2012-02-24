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
When /^I add data "([^"]*)" at \((\d+), (\d+)\)$/ do |data, x, y|
  @spatial_hash.insert_data_at(data, [x.to_i, y.to_i])
end

Then /^the cell coordinate for vertex (\d+),(\d+) is (\d+),(\d+)$/ do |vx, vy, i, j|
  rv = @spatial_hash.cell_index_for([vx.to_i,vy.to_i])
  rv.should == [i.to_i, j.to_i]
end


Then /^the hash for (\d+),(\d+) should be (\d+)$/ do |i,j,hash|
  rv = @spatial_hash.spatial_hash([i.to_i, j.to_i])
  rv.should == hash.to_i
end

Then /^the data array looks like:$/ do |table|

  data = table.rows_hash
  data.each {|k,v|
    next unless k =~ /\d+/
    vs = @spatial_hash.data[k.to_i]
    rv = vs.nil? ? "" : vs.join(",")
    rv.should == v
  }
  
end

Then /^asking for collision candidates yields:$/ do |table|
  table.map_column!('center_x') {|a| a.to_i}
  table.map_column!('center_y') {|a| a.to_i}
  table.map_column!('radius') {|a| a.to_i}
  table.hashes.each do |h|
    data = @spatial_hash.candidates(h['radius'], [h['center_x'], h['center_y']])
    
    data.join(",").should == h['candidate_data']
  end
end

