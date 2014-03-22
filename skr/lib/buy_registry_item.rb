class BuyRegistryItem
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id
  attr_accessor :type
  CONTRIBUTE = 0                            # 0 - contribute to someone else's registry ,
  #BUY_GIVER_2_REGISTRANT = 1                          # 1 - buy giver for registrant,
  ORDER = 2                                 # 2 - order a product that has already been purchased by a guest,
  EXCHANGE = 3                              # 3 - get money for a product that has already been purchased by a guest,
  BUY_REGISTRANT_FROM_REGISTRY = 4          # 4 - buy product form registry that has not been purchased by a guest.
  #CONTRIBUTE_REGISTRANT = 5                          # 5 - contribute registrant
  #BUY_REGISTRANT_NOT_FROM_REGISTRY = 6      # 6 - buy registrant for self from catalog
  EXTERNAL = 7                              # 7 - This is a purchase made outside of knack.

  attr_accessor :min_contribution, :max_contribution
  attr_accessor :min_quantity, :max_quantity
  attr_accessor :from, :notes

  attr_accessor :product_name, :description
  attr_accessor :price, :color_id, :registrant_id
  attr_accessor :main_product_thumb_url_small
  attr_accessor :main_product_thumb_url_medium

  attr_accessor :quantity, :price, :tax, :shipment
  attr_accessor :contribute # this variable is only used for the contribute dialog and should not be used anywhere else.
  attr_accessor :email # this variable is only used for the buy-external and should not be used anywhere else.

  validates :id,
            :presence => true,
            :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}

  validates :type,
            :presence => true,
            :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 7}

  validates :contribute,
            :numericality => {:greater_than_or_equal_to => :min_contribution,
                                                          :less_than_or_equal_to => :max_contribution,
                                                          :if => Proc.new { |p| p.type == CONTRIBUTE}}
  validates :from,
            :presence => true,
            :length => {:minimum => 0, :maximum => 50},
            :if => Proc.new { |p| p.type == CONTRIBUTE || p.type == EXTERNAL}

  validates :email,
            :presence => true,
            :length => {:minimum => 0, :maximum => 50},
            :email_format => true,
            :if => Proc.new { |p| p.type == EXTERNAL}

  validates :notes,
            :length => {:minimum => 0, :maximum => 300},
            :if => Proc.new { |p| !p.notes.blank?}

  validates :quantity,
            :presence => true,
            :numericality => true,
            :numericality => {:greater_than_or_equal_to => :min_quantity,
                              :less_than_or_equal_to => :max_quantity,
                              :if => Proc.new { |p| p.type == CONTRIBUTE || p.type == EXTERNAL}}


  validates :product_name,
            :presence => true

  validates :price,
            :presence => true,
            :numericality => {:greater_than_or_equal_to => 0}
  validates :color_id,
            :numericality => {:greater_than_or_equal_to => 1, :only_integer => true},
            :if => Proc.new { |p| !p.color_id.nil?}

  validates :total,
            :presence => true,
            :numericality => {:greater_than_or_equal_to => 0}
  validates :tax,
            :presence => true,
            :numericality => {:greater_than_or_equal_to => 0}
  validates :shipment,
            :presence => true,
            :numericality => {:greater_than_or_equal_to => 0}
                                            #TODO WRITE OTHER VALIDATES

                                            # Types operation
                                            # 1. Buy
                                            # 2. Contribute
                                            # 3. Withdraw cash


  def initialize(attributes = {})
    return true if attributes[:test]

    self.notes = attributes[:notes]
    self.from = attributes[:from]
    self.type = attributes[:type]
    self.email = attributes[:email]

    item = attributes[:item]

    if item
      self.id = item.id
      self.product_name = item.product.Name
      self.price = item.Price
      self.description = item.product.Description
      self.color_id = item.Color_ID
      self.main_product_thumb_url_small = item.product.main_product_thumb.url(:small)
      self.main_product_thumb_url_medium = item.product.main_product_thumb.url(:medium)
      self.registrant_id = item.Registrant_ID

      if attributes[:contribute]
        self.quantity =  item.quantity_for_contribution(attributes[:contribute].to_f)
        self.contribute = attributes[:contribute].to_f
      elsif attributes[:quantity]
        self.quantity = attributes[:quantity].to_f
        self.contribute = self.quantity * self.price
      end

      self.tax = item.Tax
      self.shipment = item.Shipment

      self.min_contribution = item.min_contribution
      self.max_contribution = item.max_contribution

      self.min_quantity = item.min_quantity
      self.max_quantity = MathUtilite.Round2Trim(item.max_quantity)

    end
  end

  def persisted?
    false
  end

  def subtotal
    MathUtilite.Round2(self.quantity * self.price)
  end

  def tax_total
    MathUtilite.Round2(self.subtotal * (self.tax / 100.0))
  end

  def shipment_total
    MathUtilite.Round2(self.quantity * self.shipment)
  end

  def total
    MathUtilite.Round2(self.subtotal + self.tax_total + self.shipment_total)
  end

  def registrant
    Registrant.find(registrant_id) if registrant_id
  end
end
