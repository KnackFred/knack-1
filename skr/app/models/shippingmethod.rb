class Shippingmethod < ActiveRecord::Base
  has_one :order
    validates_uniqueness_of :Name, :case_sensitive => false
    METHODS = {1 => "UPS", 2 => "USPS", 3 => "FedEx"}
end
