class AddExternalToContribute < ActiveRecord::Migration
  def self.up
    add_column :contributes, :external, :boolean, :default => false
  end

  def self.down
    remove_column :contributes, :external
  end
end
