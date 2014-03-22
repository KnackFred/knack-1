class ClearContributedOnDeletedItems < ActiveRecord::Migration
  # this migration set's cntributed to zero for all deleted item
  # It also set's cash to Zero.
  # NOTE: We need to manually refund any users who have cash
  # NOTE: There is no rollback for this.

  #Best practice is to use dummy classes for migration.  This way you do not run into issue with things like
  #validations being out os sync.
  class RegistryItem <ActiveRecord::Base
  end
  class Registrant <ActiveRecord::Base
  end

  def self.up
    #Reset the classes just in case they have been cached earlier.
    Registrant.reset_column_information
    RegistryItem.reset_column_information

    registrants = Registrant.where(:IsDeleted => false)
    registrants.each do |reg|
      say "Fixing registrant " + reg.Email

      if reg.Cash != 0.0
        say "Set cash from " + reg.Cash.to_s + " to zero"
        reg.Cash = 0.0
        reg.save
      else
        say "User had no cash"
      end

      items = RegistryItem.where(:IsDeleted => true, :Registrant_ID => reg.id)
      say "" + items.length.to_s + " Deleted Items"
      items.each do |item|
        if item.Contributed != 0.0
          say "Set contributed on " + item.id.to_s + " to zero was " + item.Contributed.to_s
          item.Contributed = 0.0
          item.save
        else
          say "Contribution was zero"
        end
      end
    end
  end

  def self.down
  end
end
