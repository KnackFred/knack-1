# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# PLEASE NOTE: THIS IS NOT YET COMPLETE.  SEED DATA SHOULD BE POPULATED AS REQUIRED FOR TESTING

State.create(:Name => 'Alabama', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 1 where Name = 'Alabama'")
State.create(:Name => 'Alaska', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 2 where Name = 'Alaska'")
State.create(:Name => 'Arizona', :GeneralTax => 6.6)
ActiveRecord::Base.connection.execute("update states set id = 3 where Name = 'Arizona'")
State.create(:Name => 'Arkansas', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 4 where Name = 'Arkansas'")
State.create(:Name => 'California', :GeneralTax => 8.25)
ActiveRecord::Base.connection.execute("update states set id = 5 where Name = 'California'")
State.create(:Name => 'Colorado', :GeneralTax => 2.9)
ActiveRecord::Base.connection.execute("update states set id = 6 where Name = 'Colorado'")
State.create(:Name => 'Connecticut', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 7 where Name = 'Connecticut'")
State.create(:Name => 'Delaware', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 8 where Name = 'Delaware'")
State.create(:Name => 'District of Columbia', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 9 where Name = 'District of Columbia'")
State.create(:Name => 'Florida', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 10 where Name = 'Florida'")
State.create(:Name => 'Georgia', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 11 where Name = 'Georgia'")
State.create(:Name => 'Hawaii', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 12 where Name = 'Hawaii'")
State.create(:Name => 'Idaho', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 13 where Name = 'Idaho'")
State.create(:Name => 'Illinois', :GeneralTax => 6.25)
ActiveRecord::Base.connection.execute("update states set id = 14 where Name = 'Illinois'")
State.create(:Name => 'Indiana', :GeneralTax => 7)
ActiveRecord::Base.connection.execute("update states set id = 15 where Name = 'Indiana'")
State.create(:Name => 'Iowa', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 16 where Name = 'Iowa'")
State.create(:Name => 'Kansas', :GeneralTax => 5.3)
ActiveRecord::Base.connection.execute("update states set id = 17 where Name = 'Kansas'")
State.create(:Name => 'Kentucky', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 18 where Name = 'Kentucky'")
State.create(:Name => 'Louisiana', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 19 where Name = 'Louisiana'")
State.create(:Name => 'Maine', :GeneralTax => 5)
ActiveRecord::Base.connection.execute("update states set id = 20 where Name = 'Maine'")
State.create(:Name => 'Maryland', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 21 where Name = 'Maryland'")
State.create(:Name => 'Massachusetts', :GeneralTax => 6.25)
ActiveRecord::Base.connection.execute("update states set id = 22 where Name = 'Massachusetts'")
State.create(:Name => 'Michigan', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 23 where Name = 'Michigan'")
State.create(:Name => 'Minnesota', :GeneralTax => 6.875)
ActiveRecord::Base.connection.execute("update states set id = 24 where Name = 'Minnesota'")
State.create(:Name => 'Mississippi', :GeneralTax => 7)
ActiveRecord::Base.connection.execute("update states set id = 25 where Name = 'Mississippi'")
State.create(:Name => 'Missouri', :GeneralTax => 4.225)
ActiveRecord::Base.connection.execute("update states set id = 26 where Name = 'Missouri'")
State.create(:Name => 'Montana', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 27 where Name = 'Montana'")
State.create(:Name => 'Nebraska', :GeneralTax => 5.5)
ActiveRecord::Base.connection.execute("update states set id = 28 where Name = 'Nebraska'")
State.create(:Name => 'Nevada', :GeneralTax => 6.85)
ActiveRecord::Base.connection.execute("update states set id = 29 where Name = 'Nevada'")
State.create(:Name => 'New Hampshire', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 30 where Name = 'New Hampshire'")
State.create(:Name => 'New Jersey', :GeneralTax => 7)
ActiveRecord::Base.connection.execute("update states set id = 31 where Name = 'New Jersey'")
State.create(:Name => 'New Mexico', :GeneralTax => 5.125)
ActiveRecord::Base.connection.execute("update states set id = 32 where Name = 'New Mexico'")
State.create(:Name => 'New York', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 33 where Name = 'New York'")
State.create(:Name => 'North Carolina', :GeneralTax => 5.5)
ActiveRecord::Base.connection.execute("update states set id = 34 where Name = 'North Carolina'")
State.create(:Name => 'North Dakota', :GeneralTax => 5)
ActiveRecord::Base.connection.execute("update states set id = 35 where Name = 'North Dakota'")
State.create(:Name => 'Ohio', :GeneralTax => 5.5)
ActiveRecord::Base.connection.execute("update states set id = 36 where Name = 'Ohio'")
State.create(:Name => 'Oklahoma', :GeneralTax => 4.5)
ActiveRecord::Base.connection.execute("update states set id = 37 where Name = 'Oklahoma'")
State.create(:Name => 'Oregon', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 38 where Name = 'Oregon'")
State.create(:Name => 'Pennsylvania', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 39 where Name = 'Pennsylvania'")
State.create(:Name => 'Puerto Rico', :GeneralTax => 5.5)
ActiveRecord::Base.connection.execute("update states set id = 40 where Name = 'Puerto Rico'")
State.create(:Name => 'Rhode Island', :GeneralTax => 7)
ActiveRecord::Base.connection.execute("update states set id = 41 where Name = 'Rhode Island'")
State.create(:Name => 'South Carolina', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 42 where Name = 'South Carolina'")
State.create(:Name => 'South Dakota', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 43 where Name = 'South Dakota'")
State.create(:Name => 'Tennessee', :GeneralTax => 7)
ActiveRecord::Base.connection.execute("update states set id = 44 where Name = 'Tennessee'")
State.create(:Name => 'Texas', :GeneralTax => 6.25)
ActiveRecord::Base.connection.execute("update states set id = 45 where Name = 'Texas'")
State.create(:Name => 'Utah', :GeneralTax => 4.75)
ActiveRecord::Base.connection.execute("update states set id = 46 where Name = 'Utah'")
State.create(:Name => 'Vermont', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 47 where Name = 'Vermont'")
State.create(:Name => 'Virginia', :GeneralTax => 4)
ActiveRecord::Base.connection.execute("update states set id = 48 where Name = 'Virginia'")
State.create(:Name => 'Washington', :GeneralTax => 6.5)
ActiveRecord::Base.connection.execute("update states set id = 49 where Name = 'Washington'")
State.create(:Name => 'West Virginia', :GeneralTax => 6)
ActiveRecord::Base.connection.execute("update states set id = 50 where Name = 'West Virginia'")
State.create(:Name => 'Wisconsin', :GeneralTax => 5)
ActiveRecord::Base.connection.execute("update states set id = 51 where Name = 'Wisconsin'")
State.create(:Name => 'Wyoming', :GeneralTax => 0)
ActiveRecord::Base.connection.execute("update states set id = 52 where Name = 'Wyoming'")


RegistrantType.create(:Name => 'Wedding')
ActiveRecord::Base.connection.execute("update registrant_types set id = 1 where Name = 'Wedding'")
RegistrantType.create(:Name => 'Baby')
ActiveRecord::Base.connection.execute("update registrant_types set id = 2 where Name = 'Baby'")
RegistrantType.create(:Name => 'Other')
ActiveRecord::Base.connection.execute("update registrant_types set id = 3 where Name = 'Other'")


begin
  if (Category.root.nil?)
    ActiveRecord::Base.connection.execute("insert into categories (id, name, per_shipment, parent_id, is_root) VALUES (0, 'All', 0, NULL, true)")
    ActiveRecord::Base.connection.execute("update categories set id = 0 where Name = 'All'")
  end

  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (2, 'Essentials', 0, 0, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (3, 'Experiences', 0, 0, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (4, 'Unique Gifts', 0, 0, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (5, 'Bridal Party', 0, 0, false)")

  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (6, 'Home', 0, 2, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (7, 'Kitchen', 0, 2, false)")

  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (8, 'Travel', 0, 3, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (9, 'Recreation', 0, 3, false)")

  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (10, 'Art', 0, 4, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (11, 'Furniture', 0, 4, false)")

  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (12, 'Clothing', 0, 5, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (13, 'Groomsmen Presents', 0, 5, false)")
  ActiveRecord::Base.connection.execute("insert into categories (id, Name, per_shipment, parent_id, is_root) VALUES (14, 'Bridesmaid Presents', 0, 5, false)")

rescue
  #Do nothing this is likely a duplicate ID.
end

ProductStatus.create(:Name => "Approved")
ProductStatus.create(:Name => "Not approved")
ProductStatus.create(:Name => "Pending")

Shippingmethod.create(:Name => "UPS", :Price => 0)
Shippingmethod.create(:Name => "USPS", :Price => 0)
Shippingmethod.create(:Name => "FedEx", :Price => 0)

Commission.create(:Name => 'WithDrawCash', :Percent => 5)
Commission.create(:Name => 'Knack Fee', :Percent => 10)
Commission.create(:Name => 'Knack Fee where Kind', :Percent => 15)

OrdersStatus.create(:Name => 'New')
OrdersStatus.create(:Name => 'Shipped')
OrdersStatus.create(:Name => 'Canceled')
OrdersStatus.create(:Name => 'Closed')
ActiveRecord::Base.connection.execute("update orders_statuses set id = 1 where Name = 'New'")
ActiveRecord::Base.connection.execute("update orders_statuses set id = 2 where Name = 'Shipped'")
ActiveRecord::Base.connection.execute("update orders_statuses set id = 3 where Name = 'Canceled'")
ActiveRecord::Base.connection.execute("update orders_statuses set id = 4 where Name = 'Closed'")


begin
  ActiveRecord::Base.connection.execute("insert into closed_payment_statuses (id, Name, IsDeleted) VALUES (1, 'New', false)")
  ActiveRecord::Base.connection.execute("insert into closed_payment_statuses (id, Name, IsDeleted) VALUES (2, 'Completed', false)")
rescue
  #Do nothing this is likely a duplicate ID.
end

begin
  ActiveRecord::Base.connection.execute("insert into typepayments (id, Name, IsDeleted) VALUES (1, 'PayPal', false)")
  ActiveRecord::Base.connection.execute("insert into typepayments (id, Name, IsDeleted) VALUES (2, 'CreditCard', false)")
  ActiveRecord::Base.connection.execute("insert into typepayments (id, Name, IsDeleted) VALUES (3, 'Check', false)")
  ActiveRecord::Base.connection.execute("insert into typepayments (id, Name, IsDeleted) VALUES (4, 'Knack reg.', false)")
rescue
  #Do nothing this is likely a duplicate ID.
end

namespace :dev do

end

namespace :test do

end