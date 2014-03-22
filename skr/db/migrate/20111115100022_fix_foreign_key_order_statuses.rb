class FixForeignKeyOrderStatuses < ActiveRecord::Migration
  def self.up
    execute("alter table orders drop FOREIGN KEY orderstatuses_orders_fk;")
  end

  def self.down
    execute("Alter Table orders Add CONSTRAINT `orderstatuses_orders_fk` FOREIGN KEY (`OrdersStatus_ID`) REFERENCES `orders_statuses` (`id`);")
  end
end
