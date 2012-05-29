When /^I add a temporary rendering mock with type "([^"]*)" and duration (\d+)$/ do |type, duration|
  rendering_mock = Mocha::Mock.new("renderable mock")
  rendering_mock.stubs(:position).returns(GVector.xy(42, 42))
  rendering_mock.stubs(:radius).returns(10)
  rendering_mock.stubs(:last_damage).returns(5)
  @game.rendering_controller.add_consumable_rendering(rendering_mock, eval(type), duration.to_i)
end


Then /^there should be (\d+) temporary renderings$/ do |arg1|
  @game.rendering_controller.temporary_renderings.size.should == arg1.to_i
end


Then /^the fade in color for ratio "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  include Graphics
  include GraphicsApi
  include UtilityDrawing
  extend UtilityDrawing

  fade_in_color_for(arg1.to_f).should == eval(arg2)
end