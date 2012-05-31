class Progression
  YAML_ATTRIBUTES = [:upgrade_points  ]
  ATTRIBUTES = YAML_ATTRIBUTES
  ATTRIBUTES.each {|attr| attr_accessor attr }

  include YamlHelper
  def initialize(conf)
    process_attributes(YAML_ATTRIBUTES, self, conf )
  end

end