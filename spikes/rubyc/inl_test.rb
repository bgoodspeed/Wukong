$:.unshift File.join(File.dirname(__FILE__))
require 'rubygems'
require 'inl'

require 'test/unit'

class InlTest < Test::Unit::TestCase
	def setup
		@t = MyInline.new
	end

	def test_factorial
		assert_equal 120, @t.factorial(5)
	end	

end