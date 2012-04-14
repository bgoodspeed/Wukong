When /^I expect gosu to load the image$/ do 
  Graphics::Image.expects(:new).returns("image mock")
end

When /^I create an image controller$/ do
  @image_controller = ImageController.new(@game)
  @game.image_controller = @image_controller
end

When /^I register image "([^"]*)"$/ do |arg1|
  @image_controller.register_image(arg1)
end

Then /^the image controller should be tracking (\d+) images$/ do |arg1|
  @image_controller.images.size.should == arg1.to_i
end
