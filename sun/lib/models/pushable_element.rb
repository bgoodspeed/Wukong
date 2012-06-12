class PushableElement
  YAML_ATTRIBUTES = [:position, :width, :height]
  ATTRIBUTES = YAML_ATTRIBUTES + [ :collision_radius ]
  ATTRIBUTES.each {|attr| attr_accessor attr}
  include YamlHelper
  def initialize(conf)

    process_attributes(YAML_ATTRIBUTES, self, conf, {:position => Finalizers::GVectorFinalizer.new})
    @collision_radius = [@width, @height].max
    p2 = GVector.xy(0,0)
    p3 = GVector.xy(0,0)
    p4 = GVector.xy(0,0)

    @position.plus(p2, GVector.xy(@width, 0))
    @position.plus(p3, GVector.xy(@width, @height))
    @position.plus(p4, GVector.xy(0, @height))
    @collision_type = Primitives::Rectangle.new(@position, p2, p3, p4)
  end
  def collision_center
    @position
  end

  def move(v)
    @last_move = v
    @position.plus(@position, @last_move)
    p2 = GVector.xy(0,0)
    p3 = GVector.xy(0,0)
    p4 = GVector.xy(0,0)

    @position.plus(p2, GVector.xy(@width, 0))
    @position.plus(p3, GVector.xy(@width, @height))
    @position.plus(p4, GVector.xy(0, @height))
    @collision_type = Primitives::Rectangle.new(@position, p2, p3, p4)

  end

  include Collidable
  include MovementUndoable
end