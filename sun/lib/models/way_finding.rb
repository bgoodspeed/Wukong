
class WayFinding
  def initialize(game, points = [])
    @game = game
    @points = points
    @close_enough_threshold = 5 #TODO this is dependant on the velocity of the tracker -- eg enemy
  end
  def add_point(p)
    raise "fixit" unless p.first.kind_of?(Numeric)
    @points << p
  end

  def nearest_point(position, points = @points)
    sorted = points.sort {|p1, p2| p1.distance_from(position) <=> p2.distance_from(position)}
    sorted.first
  end

  def best_point(position, target)
    current_dist = position.distance_from(target)
    candidates = @points.select do |p|
      (p.distance_from(target) < current_dist) &&
        (p.distance_from(position) > @close_enough_threshold)

    end
    nearest_point(position, candidates)
  end
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    wf = self.new(game)
    data['layer']['points'].each do |point|
      wf.add_point(point)
    end
    wf
  end

end
