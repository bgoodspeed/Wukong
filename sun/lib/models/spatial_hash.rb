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
      insert_data_at(data, ls.p2.plus(lsu.scale(step * @cell_size)))
    end
  end
  def insert_circle_type_collider(elem)
    #TODO reinstate this raise
    # raise "use a larger cell size to store elements that big #{elem.collision_radius}" unless elem.collision_radius > @cell_size
    hashes = candidate_hashes(elem.collision_radius, elem.collision_center)
    hashes.each do |hash|
      data_at(hash) << elem
    end
  end
  def insert_data_at(data, vertex, debug=false)
    ci = cell_index_for(vertex)
    idx = spatial_hash(ci)
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
    cands.uniq
  end

  #TODO this can be done all at once rather than N passes (just iterate over the space buckets)
  def dynamic_collisions(elems)
    rv = []
    elems.each do |elem|
      cs = candidates(elem.collision_radius, elem.collision_center).flatten.select do|candidate|
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
      ab = bucket.uniq
      ab.each_pair do |a,b|
        rv = @collider.check_for_collision_by_type(a,b)
        #puts "decided #{a} and #{b} collide" if rv
        cols << [a,b] if rv
      end
      
    end
    cols.uniq
  end
end
