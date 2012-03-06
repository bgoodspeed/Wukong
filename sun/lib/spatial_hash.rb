## To change this template, choose Tools | Templates
## and open the template in the editor.
#


include PrimitiveIntersectionTests
class Collider
  @@CIRCLE_CHECKS = {
    Primitives::Circle => lambda {|circle, circle2| circle_circle_intersection?(circle, circle2) },
    Primitives::LineSegment => lambda {|circle, lineseg| circle_line_segment_intersection?(circle, lineseg) }
  }
  @@LINE_SEGMENT_CHECKS = {
    Primitives::LineSegment => lambda {|ls, ls2| line_segment_line_segment_intersection?(ls, ls2)}
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
  def run_check_for(elem, candidate)
    raise "unknown type #{elem}" unless elem.class == VectorFollower
    cp = elem.current_position
    #ls = Primitives::LineSegment.new(cp, cp.plus(elem.vector)  ) #TODO migth have to be p-v, p rather than p, p+v
    ls = Primitives::LineSegment.new(cp.minus(elem.scaled_vector.scale(-1)), cp  ) #TODO migth have to be p-v, p rather than p, p+v
    line_segment_checks[candidate.class].call(ls, candidate)
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
    m = { VectorFollower => lambda {|elem| elem.collision_radius}}
    raise "collision radius needed for #{elem}" unless m.has_key?(elem.class)
    m[elem.class].call(elem)
  end
  def collision_center_for(elem)
    m = { VectorFollower => lambda {|elem| elem.collision_center}}
    raise "collision center needed for #{elem}" unless m.has_key?(elem.class)
    m[elem.class].call(elem)
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
end
