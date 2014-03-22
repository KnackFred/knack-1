class FixForeignKeyTypePayments < ActiveRecord::Migration
  def self.up
    execute("alter table orders drop FOREIGN KEY typepayment_orders_fk;")
  end

  def self.down
    execute("Alter Table orders Add CONSTRAINT `typepayment_orders_fk` FOREIGN KEY (`TypePayment_ID`) REFERENCES `type_payments` (`id`);")
  end
end
