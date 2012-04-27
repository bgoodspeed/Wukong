
class ArtificialIntelligence
  def self.from_yaml(yaml)
    data = YAML.load(yaml)
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
end
class InputController
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['input_config']
    kbd = conf['keyboard_config']
    kbd_conf = nil

    if kbd
      kbd_conf = {}
      kbd.each {|k,v|
        kbd_conf[eval(k)] = eval(v) }
    end
    gp = conf['gamepad_config']
    gp_conf = nil
    if gp
      gp_conf = {}
      gp.each {|k,v| kbd_conf[eval(k)] = eval(v) }
    end
    obj = self.new(game , kbd_conf, gp_conf)

    obj
  end
end
class CollisionResponseController
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['collision_response']
    cr = {}
    conf.each {|type1,type2c|
      t1 = eval(type1)
      cr[t1] = {} unless cr.has_key?(t1)
      type2c.each {|type2, r|
        t2 = eval(type2)
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

class InventoryController
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['inventory']
    obj = self.new(game)
    conf['items'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(Weapon, game, item ))
    end
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
    process_attributes(ATTRIBUTES, self.new(conf['image_path'], game), conf)
  end
end

class Menu
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['menu']
    obj = process_attributes(ATTRIBUTES, self.new(game, conf['menu_id']), conf)
    conf['entries'].each_with_index do |entry, index|
      game.image_controller.register_image(entry['image']) if entry['image']
      obj.add_entry(MenuEntry.new(index, entry))
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
    obj = self.new(conf['image_path'], game)
    if conf['weapon_yaml']
      w = YamlLoader.from_file(Weapon, game, conf['weapon_yaml'])
      w.orig_filename = conf['weapon_yaml']
      game.inventory_controller.register_item(w.orig_filename, w)
      obj.equip_weapon(game.inventory_controller.item_named(conf['weapon_yaml']))
    end
    process_attributes(YAML_ATTRIBUTES, obj, conf)
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
    obj = self.new(game, nil)
    obj.orig_filename = fn
    process_attributes(ATTRIBUTES, obj, conf)
  end

end

class WayFinding
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    wf = self.new(game)
    data['layer']['points'].each do |point|
      wf.add_point(point)
    end
    wf
  end

end
class YamlLoader
  def self.from_file(klass, game, f)
    klass.from_yaml(game, IO.readlines(f).join(""), f)
  end

  def self.game_from_file(f)
    GameLoader.game_from_yaml(IO.readlines(f).join(""))
  end
end
