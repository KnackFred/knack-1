class DeleteNotUsedFields < ActiveRecord::Migration
  def self.up
    execute("alter table products drop FOREIGN KEY stores_products_fk1")
    remove_column(:products, :Store_ID)
    remove_column(:stores, :Login)
    remove_column(:stores, :Password)
  end

  def self.down
    #Used execute instead so I could make the ID unsigned
    #add_column(:products, :Store_ID, :integer, :null => true)

    execute ("alter table products add column Store_ID int(11) UNSIGNED;")
    add_column(:stores, :Login, :string, :limit => 30)
    add_column(:stores, :Password, :string, :limit => 30)
    execute("alter table products add CONSTRAINT `stores_products_fk1` FOREIGN KEY (`Store_ID`) REFERENCES `stores` (`id`)")
  end
end
