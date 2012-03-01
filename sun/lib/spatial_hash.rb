## To change this template, choose Tools | Templates
## and open the template in the editor.
#


include PrimitiveIntersectionTests
class Collider
  @@CHECKS = {
    Primitives::Circle => lambda {|circle, circle2| circle_circle_intersection?(circle, circle2) },
    Primitives::LineSegment => lambda {|circle, lineseg| circle_line_segment_intersection?(circle, lineseg) }
  }
  def checks
    @@CHECKS
  end
  def check_for(type)
    c = checks[type]
    raise "No such type checker: #{type}" unless c
    c
  end
  def check_for_collision(circle, candidate)
    circle_check = check_for(candidate.class)
    circle_check.call(circle, candidate)
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
    data.select {|d| !(d.nil? or d.empty?)}
  end

  def collisions(radius, vertex)
    candidates(radius, vertex).flatten.select do |candidate|
      circle = Primitives::Circle.new(vertex, radius)
      @collider.check_for_collision(circle, candidate)
    end
  end
end
