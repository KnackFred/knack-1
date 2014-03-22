class FixCategoriesRoot < ActiveRecord::Migration
  def self.up
    add_column(:categories, :is_root, :boolean, :null => false, :default => 0)
  end

  def self.down
    remove_column(:categories, :is_root)
  end
end
