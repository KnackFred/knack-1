class OrdersStatus < ActiveRecord::Base
  has_many :orders
  validates_uniqueness_of :Name, :case_sensitive => false
  STATUSES = {1 => "New", 2 => "Shipped", 3 => "Canceled", 4 => "Closed"}
end