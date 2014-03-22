class MergeNamesInContributes < ActiveRecord::Migration
  class Contributes <ActiveRecord::Base
  end

  def self.up
    change_table :contributes do |t|
      t.string :From, :null => true, :limit => 50
    end

    Contributes.all.each do |c|
      c.FirstName = "" if c.FirstName.nil?
      c.LastName = "" if c.LastName.nil?
      c.update_attributes(:From => (c.FirstName + " " + c.LastName))
    end

    change_table :contributes do |t|
      t.remove :FirstName, :LastName
    end
  end

  def self.down
    change_table :contributes do |t|
      t.string :FirstName, :null => true, :limit => 50
      t.string :LastName, :null => true, :limit => 50
    end

    Contributes.all.each do |c|
      unless c.From.nil?
        s = c.From.split(" ", 2)
        c.update_attributes(:FirstName => (s[0]),
        :LastName => (s[1]))

      end
    end

    change_table :contributes do |t|
      t.remove :From
    end
  end
end
