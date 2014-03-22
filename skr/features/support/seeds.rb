#require File.dirname(__FILE__) + '/../../db/seeds'

  State.delete_all
  Factory.create(:state, :Name => 'Alabama', :GeneralTax => 4)
  Factory.create(:state, :Name => 'Alaska', :GeneralTax => 0)
  Factory.create(:state, :Name => 'Arizona', :GeneralTax => 6.6)
  Factory.create(:state, :Name => 'Arkansas', :GeneralTax => 6)
  Factory.create(:state, :Name => 'California', :GeneralTax => 8.25)
  Factory.create(:state, :Name => 'Colorado', :GeneralTax => 2.9)
  Factory.create(:state, :Name => 'Connecticut', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Delaware', :GeneralTax => 0)
  Factory.create(:state, :Name => 'District of Columbia', :GeneralTax => 0)
  Factory.create(:state, :Name => 'Florida', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Georgia', :GeneralTax => 4)
  Factory.create(:state, :Name => 'Hawaii', :GeneralTax => 4)
  Factory.create(:state, :Name => 'Idaho', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Illinois', :GeneralTax => 6.25)
  Factory.create(:state, :Name => 'Indiana', :GeneralTax => 7)
  Factory.create(:state, :Name => 'Iowa', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Kansas', :GeneralTax => 5.3)
  Factory.create(:state, :Name => 'Kentucky', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Louisiana', :GeneralTax => 4)
  Factory.create(:state, :Name => 'Maine', :GeneralTax => 5)
  Factory.create(:state, :Name => 'Maryland', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Massachusetts', :GeneralTax => 6.25)
  Factory.create(:state, :Name => 'Michigan', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Minnesota', :GeneralTax => 6.875)
  Factory.create(:state, :Name => 'Mississippi', :GeneralTax => 7)
  Factory.create(:state, :Name => 'Missouri', :GeneralTax => 4.225)
  Factory.create(:state, :Name => 'Montana', :GeneralTax => 0)
  Factory.create(:state, :Name => 'Nebraska', :GeneralTax => 5.5)
  Factory.create(:state, :Name => 'Nevada', :GeneralTax => 6.85)
  Factory.create(:state, :Name => 'New Hampshire', :GeneralTax => 0)
  Factory.create(:state, :Name => 'New Jersey', :GeneralTax => 7)
  Factory.create(:state, :Name => 'New Mexico', :GeneralTax => 5.125)
  Factory.create(:state, :Name => 'New York', :GeneralTax => 4)
  Factory.create(:state, :Name => 'North Carolina', :GeneralTax => 5.5)
  Factory.create(:state, :Name => 'North Dakota', :GeneralTax => 5)
  Factory.create(:state, :Name => 'Ohio', :GeneralTax => 5.5)
  Factory.create(:state, :Name => 'Oklahoma', :GeneralTax => 4.5)
  Factory.create(:state, :Name => 'Oregon', :GeneralTax => 0)
  Factory.create(:state, :Name => 'Pennsylvania', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Puerto Rico', :GeneralTax => 5.5)
  Factory.create(:state, :Name => 'Rhode Island', :GeneralTax => 7)
  Factory.create(:state, :Name => 'South Carolina', :GeneralTax => 6)
  Factory.create(:state, :Name => 'South Dakota', :GeneralTax => 4)
  Factory.create(:state, :Name => 'Tennessee', :GeneralTax => 7)
  Factory.create(:state, :Name => 'Texas', :GeneralTax => 6.25)
  Factory.create(:state, :Name => 'Utah', :GeneralTax => 4.75)
  Factory.create(:state, :Name => 'Vermont', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Virginia', :GeneralTax => 4)
  Factory.create(:state, :Name => 'Washington', :GeneralTax => 6.5)
  Factory.create(:state, :Name => 'West Virginia', :GeneralTax => 6)
  Factory.create(:state, :Name => 'Wisconsin', :GeneralTax => 5)
  Factory.create(:state, :Name => 'Wyoming', :GeneralTax => 0)

  RegistrantType.delete_all
  Factory.create(:registrant_type, :Name => 'Wedding')
  Factory.create(:registrant_type, :Name => 'Baby')
  Factory.create(:registrant_type, :Name => 'Other')

  ProductStatus.delete_all
  Factory.create(:product_status, :Name => "Approved")
  Factory.create(:product_status, :Name => "Not approved")
  Factory.create(:product_status, :Name => "Pending")

  Commission.delete_all
  Factory.create(:commission, :Name => 'WithDrawCash', :Percent => 5)
  Factory.create(:commission, :Name => 'Knack Fee', :Percent => 10)
  Factory.create(:commission, :Name => 'Knack Fee where Kind', :Percent => 15)

  Shippingmethod.delete_all
  Factory.create(:shipping_method, :Name => 'UPS')
  Factory.create(:shipping_method, :Name => 'USPS')
  Factory.create(:shipping_method, :Name => 'FedEx')

  Color.delete_all
  Factory.create(:color, :Name => 'Black', :RGB => '000000') #necessary for colour-picking scenario
  Factory.create(:color, :Name => 'Red', :RGB => 'FF0000') #necessary for colour-picking scenario
  Factory.create(:color, :Name => 'Green', :RGB => '00FF00') #necessary for colour-picking scenario
  Factory.create(:color, :Name => 'Blue', :RGB => '0000FF') #necessary for colour-picking scenario

#We recreate the root category each time because the cleaner cleans that table..
Before do
  root = Factory.create(:category, :name => 'All', :per_shipment => 0, :parent_id => 0, :is_root => true)
  Factory.create(:category, :name => 'child', :per_shipment => 7.95, :parent_id => root.id)
end