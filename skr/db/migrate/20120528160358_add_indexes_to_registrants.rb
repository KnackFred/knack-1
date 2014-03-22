class AddIndexesToRegistrants < ActiveRecord::Migration
  def self.up
    add_index :registrants, [:Email, :IsDeleted], :unique => true
    add_index :registrants, [:fbuid, :IsDeleted], :unique => true
  end

  def self.down
    remove_index :registrants, [:Email, :IsDeleted]
    remove_index :registrants, [:fbuid, :IsDeleted]
  end
end
