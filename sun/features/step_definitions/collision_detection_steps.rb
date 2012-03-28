Then /^there should be (\d+) collisions$/ do |arg1|
  @game.collisions.size.should == arg1.to_i
end