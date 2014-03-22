class RemoveIsDeletedFromContributes < ActiveRecord::Migration
  def self.up
    remove_column :contributes, :IsDeleted
  end

  def self.down
    add_column :contributes, :IsDeleted, :boolean
  end
end
