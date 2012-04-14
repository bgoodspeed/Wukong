# To change this template, choose Tools | Templates
# and open the template in the editor.

module ZOrder
  class ZO
    attr_reader :name, :value
    def initialize(n, v)
      @name = n
      @value = v
    end
  end

  def self.background
    ZO.new('background', 0)
  end
  def self.static
    ZO.new('static', 1)
  end
  def self.dynamic
    ZO.new('dynamic', 2)
  end
  def self.hud
    ZO.new('hud', 3)
  end
  def self.all
    [
      background,
      static,
      dynamic,
      hud
    ]
  end
end
