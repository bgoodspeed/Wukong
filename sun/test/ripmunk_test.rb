# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ripmunk'

class RipmunkTest < Test::Unit::TestCase
  def test_module_is_registered
    assert_not_nil(Ripmunk)
  end

  def test_can_make_a_space
    space = Ripmunk.make_space
    rv = Ripmunk.get_iterations_from_space(space)
    assert_equal 10, rv
  end

  def test_makes_a_real_space
    space = Ripmunk::Space.new
    assert_instance_of Ripmunk::Space, space
  end

  def test_can_get_properties
    space = Ripmunk::Space.new
    #space1 = Ripmunk::Space.new(1)
    #space2 = Ripmunk::Space.new(2)
    #assert_equal(1, space1.iterations)
    #assert_equal(2, space2.iterations)
    assert_equal(10, space.iterations)
  end
end
