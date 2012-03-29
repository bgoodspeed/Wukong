module YamlHelper
  def process_attributes(attrlist, instance, yaml_data)
    defined = attrlist.select{|attr| yaml_data.has_key? attr.to_s}

    defined.each {|attr|
      instance.send("#{attr}=", yaml_data[attr.to_s])
    }
  end
end
