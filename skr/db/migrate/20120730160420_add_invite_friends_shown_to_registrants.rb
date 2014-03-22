class AddInviteFriendsShownToRegistrants < ActiveRecord::Migration
  def self.up
    add_column :registrants, :invite_friends_shown, :boolean
  end

  def self.down
    remove_column :registrants, :invite_friends_shown
  end
end
