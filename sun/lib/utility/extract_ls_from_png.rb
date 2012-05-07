module PNGExtractor
  require 'chunky_png'


  MAGIC_COLOR = 4294967295
  def is_clear_color?(pixel)
    rv = (pixel == MAGIC_COLOR)
    puts "decided #{pixel} is clear? #{rv}"
    rv

  end

  def extract_linesegments(pic)
    image = ChunkyPNG::Image.from_file(pic)
    data = {}
    image.height.times do |y|
      image.row(y).each_with_index do |pixel, x|
        next if is_clear_color?(pixel)
        unless data.has_key?(pixel)
          data[pixel] = []
        end
        data[pixel] << [x,y]
      end
    end

    puts "there were #{image.height * image.width} pixels"
    puts "in #{data.keys.size} colors"
    puts "*" * 60
    puts "line_segments:"

    started = false
    data.each do |color, coords|
      next if coords.size < 2
      coords.each do |point|
        if started
          puts "    end_x: #{point[0]}"
          puts "    end_y: #{point[1]}"
          started = false
        else
          puts "  - start_x: #{point[0]}"
          puts "    start_y: #{point[1]}"
          started = true
        end
      end
    end
  end
  
end

if $0 == __FILE__
  img = ARGV.first
  raise "need to use an image argument" unless img

  include PNGExtractor

  extract_linesegments(img)
end