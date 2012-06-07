class Progression
  YAML_ATTRIBUTES = [:upgrade_points, :level_background_rank, :levels_completed  ]
  ATTRIBUTES = YAML_ATTRIBUTES
  ATTRIBUTES.each {|attr| attr_accessor attr }

  include YamlHelper
  def initialize(conf)
    @level_background_rank = @upgrade_points = 0
    @levels_completed = []
    process_attributes(YAML_ATTRIBUTES, self, conf )
  end

  def level_completed?(l)
    @levels_completed.include?(l)
  end
  def level_completed(l)
    @levels_completed << l
  end
  def to_yaml
    rv = {}
    YAML_ATTRIBUTES.each {|attr| rv[attr.to_s] = self.send(attr) }
    rv
  end

end