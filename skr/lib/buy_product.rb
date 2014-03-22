class BuyProduct
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :id
  attr_accessor :product_name, :description, :is_kind
  attr_accessor :main_product_thumb_url_small
  attr_accessor :main_product_thumb_url_medium
  attr_accessor :color_id, :color_name, :category_id, :category_name, :list_params

  attr_accessor :quantity, :price, :tax, :shipment
  
  validates :id,          
                          :presence => true,
                          :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}                       
                          
  validates :product_name,
                          :presence => true
                          
  validates :color_id,
                          :numericality => {:greater_than_or_equal_to => 1, :only_integer => true},
                          :if => Proc.new { |p| !p.color_id.nil?}

  validates :category_id,
                          :presence => true, 
                          :numericality => {:greater_than_or_equal_to => 1, :only_integer => true}

  validates :quantity,
            :presence => true,
            :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}

  validates :price,
            :presence => true,
            :numericality => {:greater_than_or_equal_to => 0}

  validates :tax,
                          :presence => true,
                          :numericality => {:greater_than_or_equal_to => 0}

  validates :shipment,
                          :presence => true,
                          :numericality => {:greater_than_or_equal_to => 0}
                          


  def initialize(attributes = {})

    product = attributes[:product]

    self.id = product.id

    self.product_name = product.Name
    self.description = product.Description
    self.category_id = product.get_category.id
    self.category_name = product.get_category.name
    self.is_kind = product.IsKind
    self.main_product_thumb_url_small = product.main_product_thumb.url(:small)
    self.main_product_thumb_url_medium = product.main_product_thumb.url(:medium)

    self.color_id = attributes[:color_id]
    if self.color_id
      self.color_name = Color.find_by_id(color_id)
    end
    if attributes[:params]
      pp = ActiveSupport::JSON.decode(attributes[:params])
      self.list_params = BuyProduct.parse_params(pp)
    else
        self.list_params = []
    end


    self.price = product.Price
    self.quantity = attributes[:quantity].to_i

    if attributes[:state_id].nil?
      self.tax = 0.0
    else
      self.tax = product.tax(attributes[:state_id])
    end

    self.shipment = MathUtilite.Round2(product.Shipment)

  end

  def update_quantity(quantity)
    return false if quantity.to_i <= 0

    self.quantity = quantity
    self.subtotal = MathUtilite.Round2(self.price * self.quantity)
    true
  end

  def subtotal
    MathUtilite.Round2(self.quantity * self.price)
  end

  def tax_total
    MathUtilite.Round2(self.subtotal * (self.tax/100.0))
  end

  def shipment_total
    MathUtilite.Round2(self.quantity * self.shipment)
  end

  def total
    MathUtilite.Round2(self.subtotal + self.tax_total + self.shipment_total)
  end



  def self.parse_params(params)
    list = Array.new
    
    if params.kind_of?(Array)
      params.each do |p|
        begin
          next if p["key"].blank? || p["value"].blank?
          pp = ProductParam.find_by_id(p["key"])
          next if pp.blank?
          value = ValueParam.find_by_id(p["value"])
          next if value.blank?
          list << ProductParams2order.new(:Name => pp.Name, :Value => value.Value)
        rescue
          next
        end
      end
    end

    return list
  end

  def persisted?
    false
  end

end