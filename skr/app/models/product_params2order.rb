class ProductParams2order < ActiveRecord::Base
  belongs_to :registry_item
  belongs_to :orders2product, :foreign_key => "Order2Product_ID"
end
