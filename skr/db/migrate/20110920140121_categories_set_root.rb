class CategoriesSetRoot < ActiveRecord::Migration
  def self.up
    execute "UPDATE categories SET is_root = 1 WHERE Name = 'All'"
  end

  def self.down
    execute "UPDATE categories SET is_root = 0 WHERE Name = 'All'"
  end
end
