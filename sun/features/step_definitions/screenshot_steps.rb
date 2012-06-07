
module PNGComparer


  def diff_images(pic1, pic2, outfile='diff.png')
    require 'chunky_png'


    images = [
      ChunkyPNG::Image.from_file(pic1),
      ChunkyPNG::Image.from_file(pic2)
    ]

    diff = []

    images.first.height.times do |y|
      images.first.row(y).each_with_index do |pixel, x|
        diff << [x,y] unless pixel == images.last[x,y]
      end
    end

    return 0 if diff.length == 0
    pixels_changed_pct  = (diff.length.to_f / images.first.pixels.length) * 100

    x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

    images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(0,255,0))
    File.delete(outfile) if File.exists?(outfile)
    images.last.save(outfile)
    pixels_changed_pct
  end
end

When /^I take a screenshot named "([^"]*)"$/ do |name|
  @screenshot_path = "tmp/#{name}"
  @screenshot_image = @game.capture_screenshot(@screenshot_path)
end

include PNGComparer

PERFECT_MATCH = 0

def compare_goldmaster(screenshot, goldmaster)
  diff_images(screenshot, goldmaster)
  
end

Then /^I it should match the goldmaster "([^"]*)"$/ do |name|
  ss = @screenshot_path
  gm = "test-data/goldmasters/#{name}"
  rv = compare_goldmaster(ss, gm)
  expected = "Comparing screenshot: #{ss} with #{gm} got 0% different"
  actual = "Comparing screenshot: #{ss} with #{gm} got #{rv}% different"
  actual.should == expected
end

