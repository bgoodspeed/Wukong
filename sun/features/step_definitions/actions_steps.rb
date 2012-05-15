
def expectall(on, a)
  stub_args = a.split(",")
  stub_args.each {|arg|
    if arg =~ /:/
      ms = arg.split(":")
      on.expects(ms[0]).returns(ms[1])
    else
      on.expects(arg)
    end
    
  }
end
def stuball(on, arg)
  stub_args = arg.split(",")
  stub_args.each {|arg|
    if arg =~ /:/
      ms = arg.split(":")
      on.stubs(ms[0]).returns(ms[1])
    else
      on.stubs(arg)
    end

    
  }
end
When /^I invoke the action "([^"]*)" with argument stubbing "([^"]*)" and expecting "([^"]*)" and set "([^"]*)"$/ do |action_name, arg2, arg3, arg4|
  m = Mocha::Mock.new("mock action arg")
  if arg2.length > 0
    stuball(m, arg2)
  end

  if arg4.length > 0
    @game.action_controller.invoke(eval(action_name), m, @game.action_controller.send(arg4))
  else
    @game.action_controller.invoke(eval(action_name), m)
  end
  
end

Then /^the game property "([^"]*)" should be "([^"]*)"$/ do |property_string, expected|
  actual = invoke_property_string_on(@game, property_string)
  actual.should == eval(expected)
end



When /^I setup a collision between stubs "([^"]*)", expects "([^"]*)" and stubs "([^"]*)", expects "([^"]*)"$/ do |c1stubs, c1expects, c2stubs, c2expects|
  e1 = Mocha::Mock.new("mock collision elem 1")
  if c1stubs.length > 0
    stuball(e1, c1stubs)
  end
  if c1expects.length > 0
    expectall(e1, c1expects)
  end


  e2 = Mocha::Mock.new("mock collision elem 2")
  if c2stubs.length > 0
    stuball(e2, c2stubs)
  end
  if c2expects.length > 0
    expectall(e2, c2expects)
  end
  @collision = Collision.new(e1,e2)
end

When /^I invoke the action "([^"]*)" on collision with set "([^"]*)"$/ do |action_name, action_set|
  if action_set.length > 0
    @game.action_controller.invoke(eval(action_name), @collision, @game.action_controller.send(action_set))
  else
    @game.action_controller.invoke(eval(action_name), @collision)
  end
  
end

When /^I invoke the action "([^"]*)" with argument "([^"]*)"$/ do |action_name, arg|
  @game.action_controller.invoke(eval(action_name), eval(arg))
end


Then /^the last saved time should be nil$/ do
  @game.clock.last_save_time.should be_nil
end

Then /^the last saved time should not be nil$/ do
  @game.clock.last_save_time.should_not be_nil
end


When /^I invoke the action "([^"]*)"$/ do |action_name|
  @game.action_controller.invoke(eval(action_name))
end

When /^I invoke the collision response "([^"]*)" on player vs anything$/ do |action_name|
  other = Mocha::Mock.new("player vs anything mock")
  c = Collision.new(@game.player, other)
  @game.action_controller.invoke(eval(action_name), c)
end