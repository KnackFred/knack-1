class ProductStatus < ActiveRecord::Base
  has_one :product
  AVAILABLE = 1
  NOT_APPROVED = 2
  PENDING = 3

  STATUSES = {AVAILABLE => "Available", NOT_APPROVED => "Not approved", PENDING => "Pending"}

end
