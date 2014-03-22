class Products2category < ActiveRecord::Base
  belongs_to :product, :foreign_key => "Product_ID"
  belongs_to :category, :foreign_key => "Category_ID"  
end
