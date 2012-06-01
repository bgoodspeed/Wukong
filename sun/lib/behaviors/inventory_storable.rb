# To change this template, choose Tools | Templates
# and open the template in the editor.

module InventoryStorable
  def inventory_hash
    "#{@display_name}:#{@orig_filename}:#{@stats.inventory_hash}"
  end
end
