class RemoveUnusedFromCategories < ActiveRecord::Migration
  def self.up
    change_table :categories do |t|
      t.remove :Description
      t.remove :Image
      t.remove :ImageGUID
      t.remove :IsDeleted
      t.integer :priority
      t.rename :Name, :name
      t.rename :Parent_ID, :parent_id
      t.rename :PerShipment, :per_shipment
    end
  end

  def self.down
    change_table :categories do |t|
      t.string :ImageGUID
      t.binary :Image
      t.boolean :IsDeleted
      t.string :Description
      t.remove :priority
      t.rename :name, :Name
      t.rename :parent_id, :Parent_ID
      t.rename :per_shipment, :PerShipment
    end
  end
end
