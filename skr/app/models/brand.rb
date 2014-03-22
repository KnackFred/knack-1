class Brand < ActiveRecord::Base
  has_many :products, :foreign_key => "Brand_ID"

  validates :Name,
                        :presence => true,
                        :length => {:minimum => 0, :maximum => 50},
                        :uniqueness => {:message => 'Brand with that name already exists', :case_sensitive => false}

  #-----------------------------------------------
  # Getting all brands for catalog with count products > 0
  #-----------------------------------------------
  def self.find_all_with_products
    Brand.order(:Name).joins(:products).group(:id).where(:products => {:IsDeleted => false, :IsKindView => true, :ProductStatus_ID => ProductStatus::STATUSES.invert['Available']})

  end
  
  def self.get_brand_id_from_product_params(product_params)
    if product_params[:BrandType].to_i == 2 # when checked "Add new brand"
      brand = Brand.where(:Name => product_params[:BrandName], :IsDeleted => false).first
      unless brand.blank?
        return brand.id # when brand exists with same name
      else
        return Brand.create(:Name => product_params[:BrandName]).id
      end
    else
      brand_id = product_params[:Brand_ID].to_i
      return nil if brand_id == 0
      return brand_id
    end
  end
end
