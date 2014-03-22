class RemoveAmountFromOrder < ActiveRecord::Migration
  def self.up
    remove_column :orders, :amount
  end

  def self.down
    add_column :orders, :amount, :decimal, :precision => 11, :scale => 2, :null => false
  end
end
