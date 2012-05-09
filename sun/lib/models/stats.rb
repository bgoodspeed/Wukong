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

  def self.zero
    s = Stats.new
    ATTRIBUTES.each {|attr| s.send("#{attr}=", 0)}
    s
  end
  include YamlHelper

  def initialize(conf_in={})
    conf = self.class.defaults.merge(conf_in)
    process_attributes(ATTRIBUTES, self, conf)
  end
  def to_yaml
    attr_to_yaml(ATTRIBUTES)
  end

  def plus_stats(other)
    rv = Stats.new
    ATTRIBUTES.each {|attr|
      rv.send("#{attr}=", other.send(attr) + self.send(attr))
    }
    rv
  end

end