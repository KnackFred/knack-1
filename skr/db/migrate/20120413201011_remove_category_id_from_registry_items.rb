class RemoveCategoryIdFromRegistryItems < ActiveRecord::Migration
  def self.up
    begin
      execute("Alter Table registry_items drop FOREIGN KEY categories_registrant2products_fk")
    rescue
       say "Unable to remove foreign key.  Was it Already Removed?"
    end
    remove_column :registry_items, :Category_ID
  end

  def self.down
    add_column :registry_items, :Category_ID, :integer
  end
end
