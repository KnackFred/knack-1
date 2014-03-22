class Products2store < ActiveRecord::Base
    belongs_to :product, :foreign_key => "Product_ID"
    belongs_to :store, :foreign_key => "Store_ID"
end
