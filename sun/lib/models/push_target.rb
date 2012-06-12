class PushTarget

  ATTRIBUTES = [:position]
  ATTRIBUTES.each {|attr| attr_accessor attr}
  include YamlHelper
  def initialize(conf)
    process_attributes(ATTRIBUTES, self, conf, {:position => Finalizers::GVectorFinalizer.new})
  end
end