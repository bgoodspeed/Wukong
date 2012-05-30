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
  def cell_x_index_for(x)
    (x/@cell_size).floor
  end
  def cell_y_index_for(y)
    (y/@cell_size).floor
  end

  def spatial_hash(x,y, x_prime, y_prime, base_table_size)
    (x_prime * x.to_i ^ y_prime * y.to_i) % base_table_size
  end

  def add_rectangle(data, r)
    add_line_segment(data, Primitives::LineSegment.new(r.p1, r.p2))
    add_line_segment(data, Primitives::LineSegment.new(r.p2, r.p3))
    add_line_segment(data, Primitives::LineSegment.new(r.p3, r.p4))
    add_line_segment(data, Primitives::LineSegment.new(r.p4, r.p1))
    add_line_segment(data, Primitives::LineSegment.new(r.p1, r.p3))
    add_line_segment(data, Primitives::LineSegment.new(r.p2, r.p4))
  end
  def add_line_segment(data, ls)
    tmp_min = GVector.xy(0,0) #NOTE temporary vector allocation
    ls.p1.minus(tmp_min, ls.p2)
    lsv = tmp_min
    tmp_u = GVector.xy(0,0) #NOTE temporary vector allocation
    lsv.unit(tmp_u)
    lsu = tmp_u
    steps = (lsv.norm).ceil
    indices = []
    indices << insert_data_at(data, ls.p1, true)

    steps.times do |step|
      #TODO move these temps out of the loop once build passes
      tmp = GVector.xy(0,0) #NOTE temporary vector allocation
      tmp_s = GVector.xy(0,0) #NOTE temporary vector allocation
      lsu.scale(tmp_s, step)
      ls.p2.plus(tmp, tmp_s)
      indices << insert_data_at(data, tmp, true)

    end

    indices.uniq
  end
  def insert_circle_type_collider(elem)
    #TODO reinstate this raise
    # raise "use a larger cell size to store elements that big #{elem.collision_radius}" unless elem.collision_radius > @cell_size
    hashes = candidate_hashes(elem.collision_radius, elem.collision_center)
    hashes.each do |hash|
      data_at(hash) << elem
    end
  end
  def insert_data_at(data, vertex, unique=false)
    cx = cell_x_index_for(vertex.x)
    cy = cell_x_index_for(vertex.y)
    idx = spatial_hash(cx, cy, @x_prime, @y_prime, @base_table_size)
    data_at(idx) << data if !unique or !data_at(idx).include?(data)
    idx
  end
  def data_at(idx)
    if @data[idx].nil?
      @data[idx] = []
    end
    @data[idx]
  end

  def candidate_hashes(radius, vertex)
    hashes = []
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    vertex.plus(tmp, GVector.xy(radius, radius))

    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy( 0     , radius))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy(-radius, radius))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy(radius, 0))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    hashes << spatial_hash(cell_x_index_for(vertex.x), cell_y_index_for(vertex.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy(-radius, 0))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy( radius, -radius))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy( 0     , -radius))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
    vertex.plus(tmp, GVector.xy(-radius, -radius))
    hashes << spatial_hash(cell_x_index_for(tmp.x), cell_y_index_for(tmp.y), @x_prime, @y_prime, @base_table_size)
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

      #TODO need to handle non circle types to get better bounds, at least linesegment
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
