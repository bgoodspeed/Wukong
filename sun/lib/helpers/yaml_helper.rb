module YamlHelper

  def process_attributes(attrlist, instance, yaml_data, finalizers={})
    #extra_data = (yaml_data.keys - attrlist)

    #extra_data.each {|ed| puts "Got unexpected key #{ed} creating #{instance.class} : #{instance}"}

    defined = attrlist.select{|attr| yaml_data.has_key? attr.to_s}
    defined.each {|attr|
      v = yaml_data[attr.to_s]
      v = finalizers[attr].call(v) if finalizers.has_key? attr
      instance.send("#{attr}=", v)
    }
    instance
  end

  def attr_to_yaml(attrs, overrides = {  })
    cf = {}
    attrs.each do |attr|
      prop = attr.to_s
      rv = self.send(attr)
      cf[prop] = rv
    end
    cf
  end

end
