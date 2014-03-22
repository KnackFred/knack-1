class AddSourceInfoToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :source_url, :string, :limit => 1024
    add_column :products, :source_name, :string, :limit => 50
  end

  def self.down
    remove_column :products, :source_url
    remove_column :products, :source_name
  end
end
