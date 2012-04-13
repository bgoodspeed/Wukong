module YamlHelper
  def process_attributes(attrlist, instance, yaml_data, finalizers={})
    defined = attrlist.select{|attr| yaml_data.has_key? attr.to_s}
    defined.each {|attr|
      v = yaml_data[attr.to_s]
      v = finalizers[attr].call(v) if finalizers.has_key? attr
      instance.send("#{attr}=", v)
    }
  end

  def attr_to_yaml(attrs, overrides = {  })
    cf = {}
    attrs.each do |attr|
      if overrides.has_key?(attr)
        rv = overrides[attr]
      else
        rv = self.send(attr)
      end
      cf[attr.to_s] = rv
    end
    cf
  end

end
