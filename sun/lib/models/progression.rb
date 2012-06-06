class Progression
  YAML_ATTRIBUTES = [:upgrade_points, :level_background_rank  ]
  ATTRIBUTES = YAML_ATTRIBUTES
  ATTRIBUTES.each {|attr| attr_accessor attr }

  include YamlHelper
  def initialize(conf)
    @level_background_rank = @upgrade_points = 0
    process_attributes(YAML_ATTRIBUTES, self, conf )
  end

end