class PushTarget

  ATTRIBUTES = [:position]
  ATTRIBUTES.each {|attr| attr_accessor attr}
  include YamlHelper
  include Collidable
  def initialize(conf)

    process_attributes(ATTRIBUTES, self, conf, {:position => Finalizers::GVectorFinalizer.new})
    @width = 25
    @height = 25
    p2 = GVector.xy(0,0)
    p3 = GVector.xy(0,0)
    p4 = GVector.xy(0,0)

    @position.plus(p2, GVector.xy(@width, 0))
    @position.plus(p3, GVector.xy(@width, @height))
    @position.plus(p4, GVector.xy(0, @height))
    @collision_type = Primitives::Rectangle.new(@position, p2, p3, p4)
  end
end