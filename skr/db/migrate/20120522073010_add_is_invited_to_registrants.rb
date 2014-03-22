class AddIsInvitedToRegistrants < ActiveRecord::Migration
  def self.up
    add_column :registrants, :is_invited, :boolean, :default => false
  end

  def self.down
    remove_column :registrants, :is_invited
  end
end
