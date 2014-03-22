class DeleteTableTaxShipments < ActiveRecord::Migration
  def self.up
    drop_table :tax_shipments
  end

  def self.down
    create_table :tax_shipments do |t|
      t.boolean  "IsDeleted",          :default => false, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "CityPlace",          :limit => 50
      t.integer  "StatePlace_ID"
      t.string   "ZIPPlace",           :limit => 20
      t.string   "CityRegistrant",     :limit => 50
      t.integer  "StateRegistrant_ID"
      t.string   "ZIPRegistrant",      :limit => 20
      t.decimal  "Tax",                :precision => 11, :scale => 2
      t.decimal  "MasterPrice",        :precision => 11, :scale => 2
      t.decimal  "Shipment",           :precision => 11, :scale => 2, :default => 0.0
    end
  end
end
