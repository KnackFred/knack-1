class SetPrimaryKeyOnSessions < ActiveRecord::Migration
  def self.up
    add_index :sessions, :session_id
  end

  def self.down
    remove_index :sessions, :session_id
  end
end
