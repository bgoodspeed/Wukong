Given /^I load the ZOrder module$/ do
  include ZOrder
end

Then /^the ordering should be:$/ do |table|
  table.map_column!('zorder value') {|a| a.to_i}
  orders = ZOrder.all
  table.hashes.each_with_index do |h, idx|
    
    
    orders[idx].name.should == h['zorder name']
    orders[idx].value.should == h['zorder value']
    
  end
end

