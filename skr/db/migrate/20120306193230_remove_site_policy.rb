class RemoveSitePolicy < ActiveRecord::Migration
  def self.up
    change_table :registrants do |t|
      t.remove :AgreeWithSitePolicy
      end
  end

  def self.down
    change_table :registrants do |t|
      t.boolean :AgreeWithSitePolicy
    end
  end
end
