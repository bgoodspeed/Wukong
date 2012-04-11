$:.unshift File.join(File.dirname(__FILE__),'..', '..','lib')

require 'ripmunk'
require 'mocha'
require 'utility_vector_math'

class Player
  #TODO faked
end

class Collider
  def check_for_collision_by_type(t1,t2)
    true
  end
end
class Array
  include ArrayVectorOperations
end

require 'spatial_hash'
require 'rspec-expectations'
#require 'shoulda/matchers'
#
##World(Shoulda::Matchers)
#World do
#  extend Shoulda::Matchers
#end