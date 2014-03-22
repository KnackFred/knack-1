class DeleteTableAdministrators < ActiveRecord::Migration
  def self.up
    drop_table :administrators
  end

  def self.down
    create_table :administrators do |t|
      t.string   "UserName",   :limit => 30, :default => "",    :null => false
      t.string   "Password",   :limit => 30, :default => "",    :null => false
      t.string   "FirstName",  :limit => 30, :default => "",    :null => false
      t.string   "LastName",   :limit => 30, :default => "",    :null => false
      t.string   "Email",      :limit => 30, :default => "",    :null => false
      t.string   "Phone",      :limit => 50
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "IsDeleted",                :default => false
    end
  end
end
