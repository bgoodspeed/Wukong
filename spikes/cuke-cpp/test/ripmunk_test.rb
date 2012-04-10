# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ripmunk'

class RipmunkTest < Test::Unit::TestCase

  def test_can_make_a_foo
#    puts "Foo methods: (#{Foo.methods - Module.methods})"
    sw = Foo.new.hello
    assert_equal "hello, world", sw

  end
end
