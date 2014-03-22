class RepurposeOrder < ActiveRecord::Migration
  def self.up
    remove_column :orders, :BillingFirstName
    remove_column :orders, :BillingLastName
    remove_column :orders, :BillingAddress
    remove_column :orders, :BillingCity
    remove_column :orders, :BillingState
    remove_column :orders, :BillingZip
    remove_column :orders, :BillingEmail
    remove_column :orders, :BillingPhone
    remove_column :orders, :ShippingFirstName
    remove_column :orders, :ShippingLastName
    remove_column :orders, :ShippingAddress
    remove_column :orders, :ShippingCity
    remove_column :orders, :ShippingState
    remove_column :orders, :ShippingZip
    remove_column :orders, :ShippingPhone
    remove_column :orders, :ShippingMethod_ID
    remove_column :orders, :BillingState_ID
    remove_column :orders, :ShippingState_ID
    remove_column :orders, :order_type
    remove_column :orders, :PaymentMethod_ID
    remove_column :orders, :PayPalEmail
    remove_column :orders, :TakeMoneyAmount
    remove_column :orders, :ShipmentTracking
    remove_column :orders, :DeliveryDate
    remove_column :orders, :OrdersStatus_ID
    remove_column :orders, :IsDeleted
    remove_column :orders, :DateTime
    rename_column :orders, :Registrant_ID, :registrant_id
    rename_column :orders, :Amount, :amount
  end

  def self.down
    rename_column :orders, :registrant_id, :Registrant_ID
    rename_column :orders, :amount, :Amount
    add_column :orders, :DateTime, :datetime, :null => false
    add_column :orders, :IsDeleted, :boolean, :default => false, :null => false
    add_column :orders, :OrdersStatus_ID, :integer
    add_column :orders, :DeliveryDate, :datetime
    add_column :orders, :ShipmentTracking, :string, :limit => 20
    add_column :orders, :TakeMoneyAmount, :decimal, :precision => 11, :scale => 2
    add_column :orders, :PayPalEmail, :string, :limit => 50
    add_column :orders, :PaymentMethod_ID, :integer
    add_column :orders, :order_type, :integer
    add_column :orders, :ShippingState_ID, :integer
    add_column :orders, :BillingState_ID, :integer
    add_column :orders, :ShippingMethod_ID, :integer
    add_column :orders, :ShippingPhone, :string, :limit => 50
    add_column :orders, :ShippingZip, :string, :limit => 20
    add_column :orders, :ShippingState, :string, :limit => 50
    add_column :orders, :ShippingCity, :string, :limit => 50
    add_column :orders, :ShippingAddress, :string, :limit => 100
    add_column :orders, :ShippingLastName, :string, :limit => 50
    add_column :orders, :ShippingFirstName, :string, :limit => 50
    add_column :orders, :BillingPhone, :string, :limit => 50
    add_column :orders, :BillingEmail, :string, :limit => 50
    add_column :orders, :BillingZip, :string, :limit => 20
    add_column :orders, :BillingState, :string, :limit => 50
    add_column :orders, :BillingCity, :string, :limit => 50
    add_column :orders, :BillingAddress, :string, :limit => 100
    add_column :orders, :BillingLastName, :string, :limit => 50
    add_column :orders, :BillingFirstName, :string, :limit => 50
  end
end
