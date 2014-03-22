class AddCopiedFromIdToRegistryItems < ActiveRecord::Migration
  def self.up
    add_column :registry_items, :copied_from_id, :integer
  end

  def self.down
    remove_column :registry_items, :copied_from_id
  end
end
