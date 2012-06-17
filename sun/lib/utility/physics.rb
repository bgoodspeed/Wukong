require 'chipmunk'
module Physics


  module Shape
    class Segment < CP::Shape::Segment; end
    class Poly < CP::Shape::Poly; end
    class Circle < CP::Shape::Circle; end
  end
  class Body < CP::Body; end
  class Space < CP::Space; end
  class Vec2 < CP::Vec2; end
end

