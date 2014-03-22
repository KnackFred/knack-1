class FixContributes < ActiveRecord::Migration
  def self.up
    change_column(:contributes, :IsDeleted, :boolean, :null => false, :default => false )
  end

  def self.down
    # We're not doing anything for down.  This really should never have been a text field
  end
end
