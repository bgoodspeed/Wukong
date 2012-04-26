# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ripmunk'


class Something
  include PrimitiveOpsCpp
end

class RipmunkTest < Test::Unit::TestCase

  def test_can_make_a_module_with_a_method
    s = Something.new
    assert_equal("hello, world", s.hello)
  end
  def test_can_make_a_module_with_a_method
    s = Something.new
    assert_equal(0, s.primitive_circle_line_segment_intersection_cpp(100,100, 1,  -10, -10, -1, -1))
    assert_equal(1, s.primitive_circle_line_segment_intersection_cpp(0,0, 100,  -10, -10, 10, 10))
  end
  def test_can_make_a_foo
#    puts "Foo methods: (#{Foo.methods - Module.methods})"
    sw = Foo.new.hello
    assert_equal "hello, world", sw

  end
end
