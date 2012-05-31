
class WayfindingGraph
  attr_accessor :nodes, :close_enough_threshold
  def initialize()
    @nodes = {}
    @edge_weights = {}
    @close_enough_threshold = 5 #TODO this is dependant on the velocity of the tracker -- eg enemy
  end

  def add_node(name, position)
    @nodes[name] = position
  end

  def add_edge(n1, n2)
    unless @edge_weights.has_key?(n1)
      @edge_weights[n1] = {}
    end
    unless @edge_weights.has_key?(n2)
      @edge_weights[n2] = {}
    end
    w = @nodes[n1].distance_from(@nodes[n2])
    @edge_weights[n1][n2] = w
    @edge_weights[n2][n1] = w
  end
  def edge_weight_for(n1,n2)
    @edge_weights[n1][n2]
  end

  def nearest_point(position)
    @nodes[closest_node_to(position)]
  end

  def best_point(position, target)
    target_dist = position.distance_from(target)
    closer = @nodes.select {|k| @nodes[k].distance_from(target) <  target_dist }
    pn = closest_node_to(position, closer)
    tn = closest_node_to(target, closer)
#    current_dist = position.distance_from(target)
#    return nil if current_dist < @close_enough_threshold
    return nil if pn.nil? or tn.nil?
    path = a_star(pn, tn)
#    nil if path.empty?
    pt = @nodes[path.first]
    pt = @nodes[path[1]] if pt.distance_from(position) < @close_enough_threshold
    pt

  end
  def closest_node_to(position, nodes=@nodes)
    ns = nodes.keys.sort{|n1, n2| nodes[n1].distance_from(position) <=> nodes[n2].distance_from(position)}
    ns.first
  end

  def neighbors_for(name)
    @edge_weights[name].keys
  end

  def heuristic(start, goal)
    sn = @nodes[start]
    gn = @nodes[goal]
    sn.distance_from(gn)
  end

  def open_node_with_lowest_fscore(open_set, f_score)

    sorted = open_set.sort {|n1, n2|
      f1 = f_score[n1]
      f2 = f_score[n2]
      f1 <=> f2}
    sorted.first
  end
  def a_star(start, goal)
    closed_set = {}
    open_set = [start]
    came_from = {}

    g_score = {}
    g_score[start] = 0
    f_score = {}
    f_score[start] = g_score[start] + heuristic(start, goal)

    while !open_set.empty?
      current = open_node_with_lowest_fscore(open_set, f_score)
      if current == goal
        return reconstruct_path(came_from, goal)
      end

      open_set -= [current]
      closed_set[current] = true
      neighbors_for(current).each do |neighbor|
        next if closed_set.has_key?(neighbor)
        tentative_g_score = g_score[current] + edge_weight_for(current, neighbor)
        if !open_set.include?(neighbor) or tentative_g_score < g_score[neighbor]
          open_set << neighbor
          came_from[neighbor] = current
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, goal)
        end


      end
    end
    return failure
  end

  def reconstruct_path(came_from, current_node)
    if came_from.has_key?(current_node)
      p = reconstruct_path(came_from, came_from[current_node])
      p << current_node
      return p
    else
      return [current_node]
    end
  end

  def failure
    []
  end
end

class WayFinding
  def initialize(game, points = [])
    @game = game
    @points = points
    @close_enough_threshold = 5 #TODO this is dependant on the velocity of the tracker -- eg enemy
  end
  def add_point(p)
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

end
