class DropTypePayments < ActiveRecord::Migration
  def self.up
    # There is a foreign key on this, it will not be re-added on a rollback..
    begin
      execute("Alter Table orders drop FOREIGN KEY TypePayment_ID")
    rescue
      say "Unable to remove foreign key TypePayement_ID on orders"
    end

    drop_table :type_payments

    rename_column :orders, :TypePayment_ID, :order_type
  end

  def self.down
    create_table :type_payments do |t|
      t.string :Name
      t.boolean :IsDeleted

      t.timestamps
    end

    rename_column :orders, :order_type, :TypePayment_ID

    ActiveRecord::Base.connection.execute("insert into type_payments (id, Name, IsDeleted) VALUES (1, 'Buy', false)")
    ActiveRecord::Base.connection.execute("insert into type_payments (id, Name, IsDeleted) VALUES (2, 'Contribute', false)")
    ActiveRecord::Base.connection.execute("insert into type_payments (id, Name, IsDeleted) VALUES (3, 'Withdraw Cash', false)")
  end
end
