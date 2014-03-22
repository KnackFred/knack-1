class RemoveShippingEmailFromOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :ShippingEmail
  end

  def self.down
    add_column :orders, :ShippingEmail, :string
  end
end
