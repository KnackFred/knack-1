class SetRegsistrantLength < ActiveRecord::Migration
  def self.up
    change_column(:registrants, :Description, :string, :limit=> 600 )
  end

  def self.down
    change_column(:registrants, :Description, :string, :limit=> 300 )
  end
end
