module MenuPositioned
  def positioned?
    rvs = entries.select {|me| me.position }
    !rvs.empty?
  end

end