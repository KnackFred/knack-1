class FixClosedPayments < ActiveRecord::Migration
  def self.up
    change_column(:closed_payments, :IsDeleted, :boolean, :null => false, :default => false )
  end

  def self.down
    change_column(:closed_payments, :IsDeleted, :integer, :limit => 1,  :default => 0, :null => false )
  end
end
