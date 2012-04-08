module YamlHelper
  def process_attributes(attrlist, instance, yaml_data, finalizers={})
    defined = attrlist.select{|attr| yaml_data.has_key? attr.to_s}
    defined.each {|attr|
      v = yaml_data[attr.to_s]
      v = finalizers[attr].call(v) if finalizers.has_key? attr
      instance.send("#{attr}=", v)
    }
  end


end
