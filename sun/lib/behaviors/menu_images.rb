module MenuImages
  def image_menu?
    imaged = entries.select {|me| me.image}
    !imaged.empty?
  end
end