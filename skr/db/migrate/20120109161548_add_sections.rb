class AddSections < ActiveRecord::Migration

  class Registrants < ActiveRecord::Base
  end

  class Section < ActiveRecord::Base
  end

  class Registry_items < ActiveRecord::Base
  end

  def self.up
    create_table :sections do |t|
      t.string :title,  :null => true, :limit => 50
      t.string :description,  :null => true, :limit => 300
      t.integer :order, :limit=> 10
      t.timestamps
      t.references :registrant
    end

    change_table :registry_items do |t|
      t.references :section
      t.integer :order
    end

    Registrant.all.each do |registry|
      sec = Section.new
      sec.registrant_id = registry.id
      sec.order = 0
      sec.save
      RegistryItem.find_all_by_Registrant_ID(registry.id).each do |item|
        item.update_attributes(:section_id => sec.id)
      end
    end

  end

  def self.down
    change_table :registry_items do |t|
      t.remove_references :section
      t.remove :order
    end

    drop_table :sections
  end
end
