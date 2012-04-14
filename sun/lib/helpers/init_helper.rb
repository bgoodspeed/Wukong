# To change this template, choose Tools | Templates
# and open the template in the editor.
class String
  def camelize
    segs = self.split("_")
    ups = segs.collect{|s| s.capitalize}
    ups.join("")
  end
end
module InitHelper
  def init_arrays(attrs, o)
    attrs.each {|attr| o.send("#{attr}=", [])}
  end

  def init_game_constructed(attrs, g)
    attrs.each {|attr|
      cls = attr.to_s.camelize
      n = Module.const_get(cls)
      g.send("#{attr}=", n.send(:new, g))
      }
  end
end
