class AddExternalToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :external, :boolean, :default => false
  end

  def self.down
    remove_column :products, :external
  end
end
