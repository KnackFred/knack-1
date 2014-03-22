class FixDefaultShipmentCategoryId < ActiveRecord::Migration
  def self.up
    change_column_default(:products, :ShipmentCategory_ID, nil)
  end

  def self.down
    change_column_default(:products, :ShipmentCategory_ID, 0)
  end
end
