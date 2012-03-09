## To change this template, choose Tools | Templates
## and open the template in the editor.
#

#TODO move this to utility module
class Array
  # define an iterator over each pair of indexes in an array
  def each_pair_index
    (0..(self.length-1)).each do |i|
      ((i+1)..(self.length-1 )).each do |j|
        yield i, j
      end
    end
  end

  # define an iterator over each pair of values in an array for easy reuse
  def each_pair
    self.each_pair_index do |i, j|
      yield self[i], self[j]
    end
  end
end

include PrimitiveIntersectionTests
class Collider
  @@CIRCLE_CHECKS = {
    Primitives::Circle => lambda {|circle, circle2| circle_circle_intersection?(circle, circle2) },
    Primitives::LineSegment => lambda {|circle, lineseg| circle_line_segment_intersection?(circle, lineseg) }
  }
  @@LINE_SEGMENT_CHECKS = {
    Primitives::LineSegment => lambda {|ls, ls2| line_segment_line_segment_intersection?(ls, ls2)},
    Primitives::Circle => lambda {|lineseg,circle| circle_line_segment_intersection?(circle, lineseg) }
  }
  def circle_checks
    @@CIRCLE_CHECKS
  end
  def line_segment_checks
    @@LINE_SEGMENT_CHECKS
  end
  def check_for(type)
    c = circle_checks[type]
    raise "No such type checker: #{type}" unless c
    c
  end
  def check_for_collision(circle, candidate)
    circle_check = check_for(candidate.class)
    
    circle_check.call(circle, candidate)
  end

  def wrap_vector_follower(elem)
    Primitives::LineSegment.new(elem.current_position, elem.current_position.plus(elem.velocity_scaled_vector)  )
  end
  def handle_vector_follower(elem, candidate)
    ls = wrap_vector_follower(elem)
    line_segment_checks[candidate.class].call(ls, candidate)
  end
  def handle_player(elem, candidate)
    cand = candidate
    c = Primitives::Circle.new(elem.collision_center, elem.collision_radius  )
    #TODO clean this design up
    if candidate.class == VectorFollower
      cand = wrap_vector_follower(candidate)
    elsif candidate.class == Player
      
    elsif candidate.class == Enemy
      cand = Primitives::Circle.new(candidate.collision_center, candidate.collision_radius )
    end
    m = circle_checks[cand.class]
    m.call(c, cand)
  end

  def handle_enemy(elem, candidate)
    cand = candidate
    c = Primitives::Circle.new(elem.collision_center, elem.collision_radius  )
    #TODO clean this design up
    if candidate.class == VectorFollower
      cand = wrap_vector_follower(candidate)
    elsif candidate.class == Player

    elsif candidate.class == Enemy
      cand = Primitives::Circle.new(candidate.collision_center, candidate.collision_radius )
    end
    m = circle_checks[cand.class]
    m.call(c, cand)
  end
  def run_check_for(elem, candidate)
    m = {
      VectorFollower => lambda {|e, c| handle_vector_follower(e, c) },
      Player => lambda {|e,c| handle_player(e, c) },
      Enemy => lambda {|e,c| handle_enemy(e, c) }
    }
    raise "unknown type #{elem}" unless m.has_key?(elem.collision_type)
    m[elem.collision_type].call(elem, candidate)
  end
  def check_for_collision_by_type(elem, candidate)
    run_check_for(elem, candidate)
  end
end

# Based on Optimized Spatial Hashing for Collision Detection of Deformable Objects
# by Matthias Teschner Bruno Heidelberger Matthias M¨uller Danat Pomeranets Markus Gross
class SpatialHash
  attr_reader :data
  attr_accessor :x_prime, :y_prime, :base_table_size
  def initialize(cell_size)
    @cell_size = cell_size
    @x_prime = 73856093
    @y_prime = 19349663
    @base_table_size = 100
    @collider = Collider.new
    @data = []
  end

  def clear
    @data = []
  end
  def cell_index_for(vertex)
    [(vertex.vx/@cell_size).floor, (vertex.vy/@cell_size).floor]
  end
 
  def spatial_hash(discretized_vertex)
    (@x_prime * discretized_vertex.vx ^ @y_prime * discretized_vertex.vy) % @base_table_size
  end
  def add_line_segment(data, ls)
    lsv = ls.p1.minus(ls.p2)
    lsu = lsv.unit
    steps = (lsv.norm/@cell_size).ceil
    steps.times do |step|
      insert_data_at(data, lsu.scale(step * @cell_size))
    end
  end
  def insert_circle_type_collider(elem)
    #TODO fix this logic too ugly
    if elem.collision_type == VectorFollower
      insert_data_at(elem, elem.collision_center)
    end
    #TODO reinstate this raise
    # raise "use a larger cell size to store elements that big #{elem.collision_radius}" unless elem.collision_radius > @cell_size
    hashes = candidate_hashes(elem.collision_radius, elem.collision_center)
    hashes.each do |hash|
      data_at(hash) << elem
    end
  end
  def insert_data_at(data, vertex)
    idx = spatial_hash(cell_index_for(vertex))
    data_at(idx) << data
  end
  def data_at(idx)
    if @data[idx].nil?
      @data[idx] = []
    end
    @data[idx]
  end

  def candidate_hashes(radius, vertex)
    hashes = []

    hashes << spatial_hash(cell_index_for(vertex.plus([ radius, radius])))
    hashes << spatial_hash(cell_index_for(vertex.plus([ 0     , radius])))
    hashes << spatial_hash(cell_index_for(vertex.plus([-radius, radius])))
    hashes << spatial_hash(cell_index_for(vertex.plus([radius, 0])))
    hashes << spatial_hash(cell_index_for(vertex))
    hashes << spatial_hash(cell_index_for(vertex.plus([-radius, 0])))
    hashes << spatial_hash(cell_index_for(vertex.plus([ radius, -radius])))
    hashes << spatial_hash(cell_index_for(vertex.plus([ 0     , -radius])))
    hashes << spatial_hash(cell_index_for(vertex.plus([-radius, -radius])))
    hashes.uniq

  end
  def candidates(radius, vertex)
    hashes = candidate_hashes(radius, vertex)
    data = hashes.collect do |idx|
      data_at(idx)
    end
    cands = data.select {|d| !(d.nil? or d.empty?)}
    cands.flatten!
    filter_ghosts(cands)
  end

  def filter_ghosts(cands)
    rv = []
    cands.each {|cand|
      matches = rv.select {|r| game_equal?(r, cand)}
      if matches.empty?
        rv << cand
      end
    }
    rv
  end
  
  def game_equal?(a, b)
    a == b
  end

  # TODO should this be all collisions? likely faster
  def player_collisions(radius, vertex)
    candidates(radius, vertex).flatten.select do |candidate|
      circle = Primitives::Circle.new(vertex, radius)
      rv = @collider.check_for_collision(circle, candidate)
      rv
    end
  end

  def collision_radius_for(elem)
    #TODO rebuild to use arbitrary collision volumes?
    m = { 
      VectorFollower => lambda {|elem| elem.collision_radius},
      Player => lambda {|elem| elem.collision_radius},
      Enemy => lambda {|elem| elem.collision_radius}

    }
    raise "collision radius needed for #{elem}" unless m.has_key?(elem.collision_type)
    m[elem.collision_type].call(elem)
  end
  def collision_center_for(elem)
    m = { 
      VectorFollower => lambda {|elem| elem.collision_center},
      Player => lambda {|elem| elem.collision_center},
      Enemy => lambda {|elem| elem.collision_center}
    }
    raise "collision center needed for #{elem}" unless m.has_key?(elem.collision_type)
    m[elem.collision_type].call(elem)
  end

  #TODO this can be done all at once rather than N passes (just iterate over the space buckets)
  def dynamic_collisions(elems)
    
    rv = []
    elems.each do |elem|
      cs = candidates(collision_radius_for(elem), collision_center_for(elem)).flatten.select do|candidate|
        
        @collider.check_for_collision_by_type(elem, candidate)
      end
      rv += cs.collect {|cand| [elem, cand]}
    end
    rv
  end

  def all_collisions
    cols = []
    @data.each_with_index do |bucket, index|
      next if bucket.nil?
      ab = filter_ghosts(bucket)
      ab.each_pair do |a,b|
        rv = @collider.check_for_collision_by_type(a,b)
        #puts "decided #{a} and #{b} collide" if rv
        cols << [a,b] if rv
      end
      
    end
    #TODO this should not be needed?
    cols.uniq
  end
end
