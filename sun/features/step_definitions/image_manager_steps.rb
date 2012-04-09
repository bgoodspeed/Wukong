When /^I expect gosu to load the image$/ do 
  Graphics::Image.expects(:new).returns("image mock")
end

When /^I create an image manager$/ do
  @image_manager = ImageManager.new(@game)
  @game.image_manager = @image_manager
end

When /^I register image "([^"]*)"$/ do |arg1|
  @image_manager.register_image(arg1)
end

Then /^the image manager should be tracking (\d+) images$/ do |arg1|
  @image_manager.images.size.should == arg1.to_i
end
