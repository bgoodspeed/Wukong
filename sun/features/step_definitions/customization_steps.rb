When /^I combine the inventory items named "([^"]*)" and "([^"]*)"$/ do |arg1, arg2|
  matching1 = p.inventory.items.keys.select {|item| item.orig_filename == arg1}
  matching2 = p.inventory.items.keys.select {|item| item.orig_filename == arg2}

  p.inventory.combine_items(matching1.first, matching2.first)
end