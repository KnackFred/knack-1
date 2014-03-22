class ProductParam < ActiveRecord::Base
  belongs_to :product, :foreign_key => "Product_ID"
  belongs_to :partner, :foreign_key => "Partner_ID"
  has_many :value_params, :foreign_key => "ProductParam_ID", :dependent => :destroy

  attr_accessor :values

  def delete_values
    self.value_params.each do |v|
      v.destroy
    end
  end

  def get_select_values
    select_values = Array.new
    return select_values + self.value_params
  end
end
