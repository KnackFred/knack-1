class RenameRegistrant2Product < ActiveRecord::Migration
  def self.up
    rename_table :registrant2products, :registry_items
    rename_table :orders2registrant2products, :orders2registry_items

    # we need to drop and re-create the foreign key
    execute("Alter Table withdrawals drop FOREIGN KEY registrant2product_withdrawals_fk")
    rename_column :withdrawals, :Registrant2Product_ID, :registry_item_id
    execute("Alter Table withdrawals Add CONSTRAINT `registry_items_withdrawals_fk` FOREIGN KEY (`registry_item_id`) REFERENCES `registry_items` (`id`)")

    execute("Alter Table contributes drop FOREIGN KEY r2p_contributes_fk;")
    rename_column :contributes, :Registrant2Products_ID, :registry_item_id
    execute("Alter Table contributes Add CONSTRAINT `registry_items_contributes_fk` FOREIGN KEY (`registry_item_id`) REFERENCES `registry_items` (`id`);")

    execute("alter table orders2registry_items drop FOREIGN KEY registrant2products_orders2registrant2products_fk;")
    rename_column :orders2registry_items, :Registrant2Product_ID, :registry_item_id
    execute("Alter Table orders2registry_items Add CONSTRAINT `registry_items_orders2registry_items_fk` FOREIGN KEY (`registry_item_id`) REFERENCES `registry_items` (`id`);")

    execute("alter table product_params2orders drop FOREIGN KEY r2p_product_params2orders_fk;")
    rename_column :product_params2orders, :Registrant2Product_ID, :registry_item_id
    execute("Alter Table product_params2orders Add CONSTRAINT `registry_item_product_params2orders_fk` FOREIGN KEY (`registry_item_id`) REFERENCES `registry_items` (`id`);")

    execute("alter table knack_payments drop FOREIGN KEY o2r2p_knack_payments_fk;")
    rename_column :knack_payments, :Order2Registrant2Product_ID, :order2registry_item_id
    execute("Alter Table knack_payments Add CONSTRAINT `order2registry_item_knack_payments_fk` FOREIGN KEY (`order2registry_item_id`) REFERENCES `orders2registry_items` (`id`);")

  end

  def self.down
    rename_table :registry_items, :registrant2products
    rename_table :orders2registry_items, :orders2registrant2products

    # we need to drop and re-create the foreign key
    execute("Alter Table withdrawals drop FOREIGN KEY registry_items_withdrawals_fk")
    rename_column :withdrawals, :registry_item_id, :Registrant2Product_ID
    execute("Alter Table withdrawals Add CONSTRAINT `registrant2product_withdrawals_fk` FOREIGN KEY (`Registrant2Product_ID`) REFERENCES `registrant2products` (`id`)")

    execute("Alter Table contributes drop FOREIGN KEY registry_items_contributes_fk;")
    rename_column :contributes, :registry_item_id, :Registrant2Products_ID
    execute("Alter Table contributes Add CONSTRAINT `r2p_contributes_fk` FOREIGN KEY (`Registrant2Products_ID`) REFERENCES `registrant2products` (`id`);")

    execute("alter table orders2registrant2products drop FOREIGN KEY registry_items_orders2registry_items_fk;")
    rename_column :orders2registrant2products, :registry_item_id, :Registrant2Product_ID
    execute("Alter Table orders2registrant2products Add CONSTRAINT `registrant2products_orders2registrant2products_fk` FOREIGN KEY (`Registrant2Product_ID`) REFERENCES `registrant2products` (`id`);")

    execute("alter table product_params2orders drop FOREIGN KEY registry_item_product_params2orders_fk;")
    rename_column :product_params2orders, :registry_item_id, :Registrant2Product_ID
    execute("Alter Table product_params2orders Add CONSTRAINT `r2p_product_params2orders_fk` FOREIGN KEY (`Registrant2Product_ID`) REFERENCES `registrant2products` (`id`);")

    execute("alter table knack_payments drop FOREIGN KEY order2registry_item_knack_payments_fk;")
    rename_column :knack_payments, :order2registry_item_id, :Order2Registrant2Product_ID
    execute("Alter Table knack_payments Add CONSTRAINT `o2r2p_knack_payments_fk` FOREIGN KEY (`Order2Registrant2Product_ID`) REFERENCES `orders2registrant2products` (`id`);")

  end
end
