class AddFromAndNotesToOrderLineItem < ActiveRecord::Migration
  def self.up
    add_column :order_line_items, :from, :string
    add_column :order_line_items, :notes, :string
  end

  def self.down
    remove_column :order_line_items, :notes
    remove_column :order_line_items, :from
  end
end
