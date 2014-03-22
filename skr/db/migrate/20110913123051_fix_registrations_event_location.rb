class FixRegistrationsEventLocation < ActiveRecord::Migration
   def self.up
    change_column(:registrants, :EventLocation, :string, :null => true)
  end

  def self.down
    change_column(:registrants, :EventLocation, :string, :null => false)
  end
end
