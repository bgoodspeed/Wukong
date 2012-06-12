module StatsMapping

  def map_speed_to_delay(stat)
    s_min = 0
    s_max = 100
    d_min = 10
    d_max = 50

    map_inverse(stat, s_min, s_max, d_min, d_max)
  end


  def map_inverse(stat, s_min, s_max, d_min, d_max)
    (((stat - s_min) * (d_min - d_max))/(s_max - s_min)) + d_max
  end
  def map_direct(stat, s_min, s_max, d_min, d_max)
    (((stat - s_min) * (d_max - d_min))/(s_max - s_min)) + d_min
  end

end