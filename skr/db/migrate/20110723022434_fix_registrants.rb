class FixRegistrants < ActiveRecord::Migration
  def self.up
    change_column(:registrants, :Email, :string, :limit=> 60 )
    change_column(:registrants, :EventDate, :datetime, :null => true)
    change_column(:registrant2products, :Ordered, :datetime, :null => true)
  end

  def self.down
    change_column(:registrants, :Email, :string, :limit=> 30 )
    change_column(:registrants, :EventDate, :datetime, :null => false, :default => "0000-00-00 00:00:00")
    change_column(:registrant2products, :Ordered, :datetime, :null => false, :default => "0000-00-00 00:00:00")
  end
end
