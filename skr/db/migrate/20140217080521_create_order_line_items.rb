class CreateOrderLineItems < ActiveRecord::Migration
  def self.up
    create_table :order_line_items do |t|
      t.integer :order_id
      t.integer :registry_item_id
      t.integer :quantity
      t.integer :amount

      t.timestamps
    end
    add_index :order_line_items, [:order_id]
    add_index :order_line_items, [:registry_item_id]
  end

  def self.down
    drop_table :order_line_items
  end
end
