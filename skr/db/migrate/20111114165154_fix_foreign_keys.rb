class FixForeignKeys < ActiveRecord::Migration
  def self.up
    execute("alter table products drop FOREIGN KEY products_fk;")
    execute("alter table stores drop FOREIGN KEY stores_fk;")
    drop_table(:store_types)
    change_table :stores do |t|
      t.remove :StoreType_ID
    end
  end

  def self.down
    create_table :store_types do |t|
      t.string   "Name",       :limit => 50, :default => "",    :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "IsDeleted",                :default => false, :null => false
    end
    change_table :stores do |t|
      t.integer  "StoreType_ID",  :null => false
    end
    execute("Alter Table products Add CONSTRAINT `products_fk` FOREIGN KEY (`ProductStatus_ID`) REFERENCES `product_statuses` (`id`);")
    execute("Alter Table stores Add CONSTRAINT `stores_fk` FOREIGN KEY (`StoreType_ID`) REFERENCES `store_types` (`id`);")
  end
end
