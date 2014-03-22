class CleanupRegistryItems < ActiveRecord::Migration
  def self.up
    remove_column :registry_items, :AlocatedMoney
    remove_column :registry_items, :Notes
    remove_column :registry_items, :Ordered
    remove_column :registry_items, :OrderNumber
  end

  def self.down
    add_column :registry_items, :AlocatedMoney, :decimal
    add_column :registry_items, :Notes, :string
    add_column :registry_items, :Ordered, :datetime
    add_column :registry_items, :OrderNumber, :integer
  end
end
