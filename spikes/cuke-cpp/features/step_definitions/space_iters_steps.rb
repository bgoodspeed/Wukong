
Given /^I create a space$/ do
  @space = Ripmunk::Space.new
end

When /^I ask for the number of iterations$/ do
  @rv = @space.iterations
end

Then /^I should get (\d+)$/ do |iters|
  @rv.should == iters.to_i
end
