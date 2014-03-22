class AddFieldPriorityAndChangeFieldCountView < ActiveRecord::Migration
  def self.up
    rename_column :products, :CountView, :count_view
    add_column(:products, :priority, :integer, :null => false, :default => 0)
  end

  def self.down
    rename_column :products, :count_view, :CountView
    remove_column(:products, :priority)
  end
end
