class DropUnneededTables < ActiveRecord::Migration
  def self.up
    drop_table :orders2registry_items
    drop_table :orders2products
  end

  def self.down
    create_table :orders2products, :force => true do |t|
      t.integer  :Order_ID,                                                     :null => false
      t.integer  :Product_ID,                                                   :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :IsDeleted,                                 :default => false, :null => false
      t.integer  :Color_ID
      t.integer  :Quantity,                                                     :null => false
      t.decimal  :Tax,        :precision => 11, :scale => 2, :default => 0.0,   :null => false
      t.decimal  :Shipment,   :precision => 11, :scale => 2, :default => 0.0,   :null => false
      t.decimal  :Price,      :precision => 11, :scale => 2,                    :null => false
      t.integer  :status_id,                                 :default => 1,     :null => false
    end

    add_index :orders2products, [:Color_ID], :name => :colors_orders2products_fk
    add_index :orders2products, [:Order_ID], :name => :orders_orders2products_fk
    add_index :orders2products, [:Product_ID], :name => :products_orders2products_fk

    create_table :orders2registry_items, :force => true do |t|
      t.integer  :Order_ID,                            :null => false
      t.integer  :registry_item_id,                    :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :IsDeleted,        :default => false, :null => false
      t.integer  :Contribute_ID
      t.boolean  :IsGetMoney,       :default => false, :null => false
      t.integer  :status_id,        :default => 1,     :null => false
    end
    add_index :orders2registry_items, [:Contribute_ID], :name => :contributes_orders2registrant2products_fk
    add_index :orders2registry_items, [:Order_ID], :name => :orders_orders2registrant2products_fk
    add_index :orders2registry_items, [:registry_item_id], :name => :registrant2products_orders2registrant2products_fk
  end
end
