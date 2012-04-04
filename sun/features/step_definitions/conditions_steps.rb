Given /^I create a condition manager$/ do
  @condition_manager = ConditionManager.new(@game)
  @game.condition_manager = @condition_manager
end

Given /^I stub "([^"]*)" on game to return "([^"]*)"$/ do |m, rv|
  @game.stubs(m).returns(eval(rv)) 
end

def eval_handle_vector(rs)
  (rs =~ /,/) ? to_vector(rs) : eval(rs)
end
def handle_vector(rs)
  (rs =~ /,/) ? to_vector(rs) : rs
end

Given /^I stub "([^"]*)" on games "([^"]*)" to return "([^"]*)"$/ do |fn, gameprop, rs|
  obj = @game.send(gameprop)
  
  obj.stubs(fn).returns(eval_handle_vector(rs))
end

When /^I add a fake condition that checks "([^"]*)" on game named "([^"]*)"$/ do |gameprop, name|
  cond = lambda {|game, unused| game.send(gameprop)}
  @condition_manager.register_condition(name, cond)
end

Then /^asking if game condition "([^"]*)" is met should be "([^"]*)"$/ do |name, rv|
  @condition_manager.condition_met?(name).should == eval(rv)
end

Then /^asking if game condition "([^"]*)" with arg "([^"]*)" is met should be "([^"]*)"$/ do |name, arg, rs|
  rv = eval(rs)
  argv = handle_vector(arg)
  @condition_manager.condition_met?(name, argv).should be(rv), "Expected condtion #{name}(#{arg}) to be #{rv}"
end
