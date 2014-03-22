class AddForeignKeyToSections < ActiveRecord::Migration
  def self.up
    # Run this and delete any sections that do not meet the constraints.
    # select sections.id, sections.registrant_id from sections left join registrants on sections.registrant_id = registrants.id where registrants.id is null;

    execute "ALTER TABLE sections CHANGE COLUMN registrant_id registrant_id INT UNSIGNED"
    execute "ALTER TABLE sections ADD CONSTRAINT `registrant_fk` FOREIGN KEY (`registrant_id`) REFERENCES `registrants` (`id`);"

  end

  def self.down
    execute "ALTER TABLE sections DROP FOREIGN KEY registrant_fk;"
    execute "ALTER TABLE sections CHANGE COLUMN registrant_id registrant_id INT"
  end
end
