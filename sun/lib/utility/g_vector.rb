
class GVector
  attr_accessor :x,:y

  def self.xy(x,y)
    GVector.new(x,y)
  end
  def initialize(x,y)
    @x = x
    @y = y
  end

  def min
    (x < y) ? x : y
  end
  def max
    (x < y) ? y : x
  end
  def <=>(other)
    xrv = (x.to_f <=> other.x.to_f)
    xrv == 0 ? (y.to_f <=> other.y.to_f) : xrv
  end
  def ==(other)
    x == other.x and y == other.y
  end

  def to_s
    "[#{x}, #{y}]"
  end

  #HACK this is hard coded to 2d
  def sum2d
    x + y
  end

  #HACK this is hard coded to 2d
  def dot(other)
#    rvs = gather_up_as(:*, other)
    rvs = GVector.xy(0,0)
    rvs.x = x * other.x
    rvs.y = y * other.y
    rvs.sum2d
  end

  def norm
    Math.sqrt(dot(self))
  end
  def unit(rv)
    n = norm.to_f
    raise "cannot take the unit of a zero sized vector" if n == 0.0
    scale_factor = 1.0/n

    scale(rv, scale_factor)
    rv
  end
  def distance_from(other)
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    tmp = self.minus(tmp, other)
    tmp.norm
  end

  #HACK hardcoded to 2d
  def scale(rv, factor)
    rv.x = x*factor
    rv.y = y*factor
    rv
  end

  #HACK 2d specific
  def minus(rv, other)
    rv.x = self.x - other.x
    rv.y = self.y - other.y
    rv
  end
  def plus(rv, other)
    rv.x = self.x + other.x
    rv.y = self.y + other.y
    rv
  end

end
