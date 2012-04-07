When /^I invoke the action "([^"]*)" with argument stubbing "([^"]*)" and expecting "([^"]*)"$/ do |action_name, arg2, arg3|
  m = Mocha::Mock.new("mock action arg")
  if arg2.length > 0
    stub_args = arg2.split(",")
    stub_args.each {|arg|
      m.stubs(arg)
    }
  end
  @game.action_manager.invoke(eval(action_name), m)
end

Then /^the game property "([^"]*)" should be "([^"]*)"$/ do |property_string, expected|
  actual = invoke_property_string_on(@game, property_string)
  eval(expected).should == actual
end

