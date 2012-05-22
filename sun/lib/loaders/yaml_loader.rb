
class ArtificialIntelligence


  def self.from_conf(data)
    statemachine = Statemachine.build do
      data['strategy']['states'].each do |stateconf|
        stateconf.each do |state_name, targets|
          targets.each do |target|
            target.each do |action_condition, dest_state|
              trans state_name.to_sym, action_condition.to_sym, dest_state.to_sym
            end
          end
        end
      end
    end

    self.new(statemachine)

  end

  def self.from_yaml(yaml)
    data = YAML.load(yaml)
    ArtificialIntelligence.from_conf(data)
  end
end
class InputController
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['input_config']
    kbd_conf = evaluated_config(conf, 'keyboard_config')
    gp_conf = evaluated_config(conf, 'gamepad_config')

    obj = self.new(game , kbd_conf, gp_conf)

    obj
  end

  def self.evaluated_config(conf, name)
    return nil unless conf.has_key? name
    rv = {}
    conf[name].each {|k,v| rv[eval(k)] = eval(v)}
    rv
  end
end
class CollisionResponseController
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['collision_response']
    cr = {}
    conf.each {|type1,type2c|
      t1 = type1
      cr[t1] = {} unless cr.has_key?(t1)
      type2c.each {|type2, r|
        t2 = type2
        rs = r.collect {|e| e.to_sym}
        cr[t1][t2] = rs
      }
    }

    obj = self.new(game, cr)

    obj
  end
end
class Inventory
  extend YamlHelper
  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)

    conf = data['inventory']
    obj = self.new( game, nil) #TODO we don't know who the owner is at this point
    conf['items'].to_a.each {|hash|
      raise "bad inventory yaml " unless hash.size == 1
      obj.add_item(hash.keys.first, hash.values.first)
    }
    if conf['weapon']
      obj.weapon = game.inventory_controller.item_named(conf['weapon'])
    end
    obj
  end
end

class GameItem
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['item']
    obj = self.new(game, conf)
    process_attributes(ATTRIBUTES, obj, conf)
  end
end

class InventoryController
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['inventory']
    obj = self.new(game)
    conf['weapons'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(Weapon, game, item ))
    end
    conf['items'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(GameItem, game, item ))
    end
    #TODO will need armor here as well
    obj
  end

end
class HeadsUpDisplay
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    process_attributes(ATTRIBUTES, self.new(game), YAML.load(yaml)['heads_up_display'])
  end
end

class Enemy
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['enemy']
    self.new(game, conf )
  end
end

class Menu
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['menu']
    obj = process_attributes(ATTRIBUTES, self.new(game, conf['menu_id']), conf,  {:header_position => Finalizers::GVectorFinalizer.new})
    conf['entries'].each_with_index do |entry, index|
      game.image_controller.register_image(entry['image']) if entry['image']
      obj.add_entry(MenuEntry.new(game, index, entry))
    end
    obj
  end
end

class Player
  extend YamlHelper
  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['player']
    obj = self.new(game, conf)
    if conf['weapon_yaml']
      w = YamlLoader.from_file(Weapon, game, conf['weapon_yaml'])
      w.orig_filename = conf['weapon_yaml']
      game.inventory_controller.register_item(w.orig_filename, w)
      obj.equip_weapon(game.inventory_controller.item_named(conf['weapon_yaml']))
    end
    obj
  end
end

class SaveData
  extend YamlHelper
  include YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    process_attributes(ATTRIBUTES, self.new, YAML.load(yaml)['savedata'])
  end
end

class Weapon
  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, fn="unknown")
    data = YAML.load(yaml)
    conf = data['weapon']
    obj = self.new(game, nil, conf)
    obj.orig_filename = fn
    process_attributes(ATTRIBUTES, obj, conf)
  end

end

class WayFinding
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    wf = self.new(game)
    if data['layer']['points']
      data['layer']['points'].each do |point|
        wf.add_point(GVector.xy(point[0], point[1]))
      end
      return wf
    end
    if data['layer']['nodes']
      return WayfindingGraph.from_yaml(game, yaml)
    end

  end

end
class WayfindingGraph
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    wf = self.new
    data['layer']['nodes'].each do |node|
      wf.add_node(node['name'], GVector.xy(node["position"][0], node["position"][1]))
    end
    data['layer']['edges'].each do |edge_conf|
      n1 = edge_conf.first
      rest = edge_conf.last
      rest.each {|n2|
        wf.add_edge(n1, n2)
      }
    end
    wf
  end

end
class YamlLoader
  def self.from_file(klass, game, f)
    klass.from_yaml(game, IO.readlines(f).join(""), f)
  end

  def self.game_from_file(f)
    GameLoader.game_from_yaml(IO.readlines(f).join(""), f)
  end
end
