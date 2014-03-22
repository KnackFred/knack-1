class CreateFollowsTable < ActiveRecord::Migration
  def self.up
    create_table :follows do |t|
      t.timestamps
      t.references :registrant
      t.references :followed
    end

    execute "ALTER TABLE follows CHANGE COLUMN followed_id followed_id INT UNSIGNED"
    execute "ALTER TABLE follows CHANGE COLUMN registrant_id registrant_id INT UNSIGNED"
    execute "ALTER TABLE follows ADD CONSTRAINT `follows_registrant_fk` FOREIGN KEY (`registrant_id`) REFERENCES `registrants` (`id`);"
    execute "ALTER TABLE follows ADD CONSTRAINT `followed_registrant_fk` FOREIGN KEY (`followed_id`) REFERENCES `registrants` (`id`);"

  end

  def self.down
    drop_table :follows
  end
end
