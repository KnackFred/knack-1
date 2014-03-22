class AddVisibleToStore < ActiveRecord::Migration
  class Category <ActiveRecord::Base
  end

  def self.up
    add_column :stores, :visible, :boolean, :default => false
    Store.update_all :visible => true
  end

  def self.down
    remove_column :stores, :visible
  end
end
