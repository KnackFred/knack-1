class ValueParam < ActiveRecord::Base
  belongs_to :product_param, :foreign_key => "ProductParam_ID"
end
