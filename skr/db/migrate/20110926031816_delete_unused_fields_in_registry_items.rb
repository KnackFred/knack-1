class DeleteUnusedFieldsInRegistryItems < ActiveRecord::Migration
  def self.up
    execute("alter table myproducts drop FOREIGN KEY categories_myproducts_fk;")
    execute("alter table order_lines drop FOREIGN KEY order_lines_fk;")
    execute("alter table registry_items drop FOREIGN KEY myprodcuts_registrant2products_fk;")
    change_table :registry_items do |t|
      t.remove :MyProduct_ID
      t.remove :StoreName
      t.remove :StoreWebSite
      t.remove :Action_ID
    end
    drop_table(:myproducts)
  end

  def self.down
    change_table :registry_items do |t|
      t.integer :MyProduct_ID
      t.string :StoreName, :limit => 50
      t.string :StoreWebSite, :limit => 300
      t.integer :Action_ID, :default => 3
    end
    #myproducts was not used so you don;t really need it back.
    #create_table :myproducts do |t|
    #  t.string :name
    #end
    ##execute("Alter Table myproducts Add CONSTRAINT `categories_myproducts_fk` FOREIGN KEY (`Category_ID`) REFERENCES `categories` (`id`)")
    #execute("Alter Table order_lines Add CONSTRAINT `order_lines_fk` FOREIGN KEY (`MyProduct_ID`) REFERENCES `myproducts` (`id`)")
    #execute("Alter table registry_items add CONSTRAINT `myprodcuts_registrant2products_fk` FOREIGN KEY (`MyProduct_ID`) RERENCES `myproducts` (`id`)")

  end
end
