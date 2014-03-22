class FixClosedPaymentStatuses < ActiveRecord::Migration
  def self.up
    change_column(:closed_payment_statuses, :IsDeleted, :boolean, :null => false, :default => false )
  end

  def self.down
    change_column(:closed_payment_statuses, :IsDeleted, :integer, :limit => 1,  :default => 0, :null => false )
  end
end
