class AddExtColumnsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :ext_color, :string, :limit => 50
    add_column :products, :ext_size, :string, :limit => 50
    add_column :products, :ext_other, :string, :limit => 100
  end

  def self.down
    remove_column :products, :ext_other
    remove_column :products, :ext_size
    remove_column :products, :ext_color
  end
end
