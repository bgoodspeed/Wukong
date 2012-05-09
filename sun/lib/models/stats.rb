class Stats
  ATTRIBUTES = [ :strength, :defense, :health, :max_health, :speed, :accuracy]
  ATTRIBUTES.each {|at| attr_accessor at}
  def self.defaults
    {
        'strength' => 10,
       'defense' => 5,
        'health' => 10,
        'max_health' => 12,
        'speed' => 5,
        'accuracy' => 5,
    }
  end
  include YamlHelper

  def initialize(game, conf_in={})
    conf = self.class.defaults.merge(conf_in)
    process_attributes(ATTRIBUTES, self, conf)
  end
  def to_yaml
    attr_to_yaml(ATTRIBUTES)
  end

end