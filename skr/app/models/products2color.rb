class Products2color < ActiveRecord::Base
  belongs_to :product, :foreign_key => "Product_ID"
  belongs_to :color, :foreign_key => "Color_ID"
end
