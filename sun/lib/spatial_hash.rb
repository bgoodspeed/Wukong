# To change this template, choose Tools | Templates
# and open the template in the editor.

class Array
  def vx
    self[0]
  end
  def vy
    self[1]
  end
  def add_to(other)
    rv = []
    self.each_with_index {|value, idx| rv[idx] = value + other[idx] }
    rv
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
  
  def candidates(radius, vertex)
    hashes = []
    
    hashes << spatial_hash(cell_index_for(vertex.add_to([ radius, radius])))
    hashes << spatial_hash(cell_index_for(vertex.add_to([ 0     , radius])))
    hashes << spatial_hash(cell_index_for(vertex.add_to([-radius, radius])))
    hashes << spatial_hash(cell_index_for(vertex.add_to([radius, 0])))
    hashes << spatial_hash(cell_index_for(vertex))
    hashes << spatial_hash(cell_index_for(vertex.add_to([-radius, 0])))
    hashes << spatial_hash(cell_index_for(vertex.add_to([ radius, -radius])))
    hashes << spatial_hash(cell_index_for(vertex.add_to([ 0     , -radius])))
    hashes << spatial_hash(cell_index_for(vertex.add_to([-radius, -radius])))
    hashes.uniq!
    data = hashes.collect do |idx|
      data_at(idx)
    end
    data.select {|d| !(d.nil? or d.empty?)}
  end
end
