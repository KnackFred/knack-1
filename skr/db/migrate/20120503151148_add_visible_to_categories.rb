class AddVisibleToCategories < ActiveRecord::Migration
  class Category <ActiveRecord::Base
  end

  def self.up
    add_column :categories, :visible, :boolean, :default => false
    Category.update_all :visible => true
  end

  def self.down
    remove_column :categories, :visible
  end
end
