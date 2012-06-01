
class ArtificialIntelligenceLoader


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

    ArtificialIntelligence.new(statemachine)

  end

  def self.from_yaml(yaml)
    data = YAML.load(yaml)
    ArtificialIntelligenceLoader.from_conf(data)
  end
end
class SoundControllerLoader
  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['sound_controller']
    obj = SoundController.new(game)

    process_sound_array(game, obj, conf, 'effects', 'sound effect', "add_effect")
    process_sound_array(game, obj, conf, 'songs', 'song', "add_song")

    obj
  end

  def self.process_sound_array(game, obj, conf, conf_name, type, add_method)
    conf[conf_name].each {|effect|
      game.log.info("Adding #{type} named #{effect['name']} from file #{effect['filename']}")
      obj.send(add_method, effect['filename'], effect['name'])
    }

  end

end
class InputControllerLoader
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['input_config']
    kbd_conf = evaluated_config(conf, 'keyboard_config')
    gp_conf = evaluated_config(conf, 'gamepad_config')

    obj = InputController.new(game , kbd_conf, gp_conf)

    obj
  end

  def self.evaluated_config(conf, name)
    return nil unless conf.has_key? name
    rv = {}
    conf[name].each {|k,v| rv[eval(k)] = eval(v)}
    rv
  end
end
class CollisionResponseControllerLoader
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

    obj = CollisionResponseController.new(game, cr)

    obj
  end
end
class InventoryLoader
  extend YamlHelper
  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)

    conf = data['inventory']
    obj = Inventory.new( game, nil) #TODO we don't know who the owner is at this point
    conf['items'].to_a.each {|hash|
      raise "bad inventory yaml " unless hash.size == 1
      item_name =  hash.keys.first
      item_quantity = hash.values.first
      item = game.inventory_controller.item_named(item_name)
      obj.add_item(item,item_quantity )
    }
    if conf['weapon']
      obj.weapon = game.inventory_controller.item_named(conf['weapon'])
    end
    obj
  end
end

class GameItemLoader
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['item']
    obj = GameItem.new(game, conf)
    process_attributes(GameItem::ATTRIBUTES, obj, conf)
  end
end

class InventoryControllerLoader
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['inventory']
    obj = InventoryController.new(game)
    conf['weapons'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(Weapon, game, item ))
    end
    conf['items'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(GameItem, game, item ))
    end
    conf['armors'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(Armor, game, item ))
    end
    #TODO will need armor here as well
    obj
  end

end

class ArmorLoader
  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['armor']
    obj = Armor.new(game, conf)
    process_attributes(Armor::ATTRIBUTES, obj, conf)
  end

end
class HeadsUpDisplayLoader
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    process_attributes(HeadsUpDisplay::ATTRIBUTES, HeadsUpDisplay.new(game), YAML.load(yaml)['heads_up_display'])
  end
end

class EnemyLoader
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['enemy']
    inventory = YamlLoader.from_file(Inventory, game,conf['inventory_file']) if conf['inventory_file']
    conf['inventory'] = inventory
    e = Enemy.new(game, conf )
    if conf['weapon']
      w = YamlLoader.from_file(Weapon, game, conf['weapon'])
      w.orig_filename = conf['weapon']
      game.inventory_controller.register_item(w.orig_filename, w)

      wpn = game.inventory_controller.item_named(conf['weapon'])
      e.equip_weapon wpn
    end
    e
  end
end

class MenuLoader
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['menu']
    obj = process_attributes(Menu::ATTRIBUTES, Menu.new(game, conf['menu_id']), conf,  {:header_position => Finalizers::GVectorFinalizer.new})
    conf['entries'].each_with_index do |entry, index|
      game.image_controller.register_image(entry['image']) if entry['image']
      obj.add_entry(MenuEntry.new(game, index, entry))
    end
    conf['headers'].to_a.each do |header|

      obj.add_header(MenuHeader.new(header['header_text'], Finalizers::GVectorFinalizer.new.call(header['header_position'])))
    end
    obj
  end
end

class PlayerLoader
  extend YamlHelper
  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['player']
    conf['inventory'] = YamlLoader.from_file(Inventory, game,conf['inventory_file']) if conf['inventory_file']
    obj = Player.new(game, conf)
    if conf['weapon_yaml']
      w = YamlLoader.from_file(Weapon, game, conf['weapon_yaml'])
      w.orig_filename = conf['weapon_yaml']
      game.inventory_controller.register_item(w.orig_filename, w)

      obj.equip_weapon(game.inventory_controller.item_named(conf['weapon_yaml']))
    end
    obj
  end
end

class SaveDataLoader
  extend YamlHelper
  include YamlHelper
  def self.from_yaml(game, yaml, f=nil)
    process_attributes(SaveData::ATTRIBUTES, SaveData.new, YAML.load(yaml)['savedata'])
  end
end

class WeaponLoader
  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, fn="unknown")
    data = YAML.load(yaml)
    conf = data['weapon']
    obj = Weapon.new(game, nil, conf)
    obj.orig_filename = fn

    game.image_controller.register_image(conf['equipment_image_path']) if conf['equipment_image_path']


    process_attributes(Weapon::ATTRIBUTES, obj, conf)
  end

end

class WayFindingLoader
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    wf = WayFinding.new(game)
    if data['layer']['points']
      data['layer']['points'].each do |point|
        wf.add_point(GVector.xy(point[0], point[1]))
      end
      return wf
    end
    if data['layer']['nodes']
      return WayfindingGraphLoader.from_yaml(game, yaml)
    end

  end

end
class WayfindingGraphLoader
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    wf = WayfindingGraph.new
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
    c = const_get("#{klass}Loader".to_sym)
    c.from_yaml(game, IO.readlines(f).join(""), f)
  end

  def self.game_from_file(f)
    GameLoader.game_from_yaml(IO.readlines(f).join(""), f)
  end
end
