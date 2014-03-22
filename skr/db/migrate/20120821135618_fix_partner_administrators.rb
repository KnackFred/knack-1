class FixPartnerAdministrators < ActiveRecord::Migration
  def self.up
    change_table :partner_administrators do |t|
      t.rename :Partner_ID, :partner_id
      t.rename :Email, :email
      t.rename :FirstName, :first_name
      t.rename :LastName, :last_name
      t.rename :IsDeleted, :is_deleted
      t.rename :Password, :password
      t.rename :Phone, :phone
      t.remove :Login
    end

  end

  def self.down
    change_table :partner_administrators do |t|
      t.rename :partner_id, :Partner_ID
      t.rename :email, :Email
      t.rename :first_name, :FirstName
      t.rename :last_name, :LastName
      t.rename :is_deleted, :IsDeleted
      t.rename :password, :Password
      t.rename :phone, :Phone
      t.string :Login
    end
  end
end
