When /^I combine the inventory items named "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  matching1 = p.inventory.items.keys.select {|item| item =~ Regexp.new(arg1)}
  matching2 = p.inventory.items.keys.select {|item| item =~ Regexp.new(arg2)}
  m1 = matching1.first
  m2 = matching2.first
  p.inventory.combine_items(p.inventory.items[m1].item, p.inventory.items[m2].item)
end