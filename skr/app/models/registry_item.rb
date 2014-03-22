class RegistryItem < ActiveRecord::Base
  belongs_to :product, :foreign_key => "Product_ID"
  accepts_nested_attributes_for :product, :reject_if => :reject_product_updates

  belongs_to :registrant, :foreign_key => "Registrant_ID"

  belongs_to :copied_from, :class_name => "RegistryItem"
  has_many :copied_to, :class_name => "RegistryItem", :foreign_key => "copied_from_id"

  belongs_to :color, :foreign_key => 'Color_ID'

  belongs_to :section

  has_one :withdrawal, :foreign_key => "registry_item_id"

  has_many :contributes, :foreign_key => "registry_item_id", :inverse_of => :registry_item

  has_many :order_line_items, :inverse_of => :registry_item

  has_many :orders, :through => :order_line_items, :uniq => true

  validates :Quantity,
                        :presence => true,
                        :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}

  validates :Contributed,
                        :numericality => true

  validates :IsDeleted,
                        :inclusion => { :in => [true, false] }

  validates :IsToolbar,
                        :inclusion => { :in => [true, false] }

  validates :Purchased_ID,
                        :inclusion => { :in => [1, 2, 3] } # Available, Ordered, Purchased

  validates :Registrant_ID,
                        :presence => true

  has_many :orders2registry_items, :foreign_key => "registry_item_id"

  has_many   :product_params2orders, :foreign_key => "registry_item_id"

  AVAILABLE  = 2
  PURCHASED = 1
  ORDERED = 3

  MIN_CONTRIBUTE = 10.0
  MIN_QUANTITY = 0.01

  before_save :set_default_section

  scope :editable, where(:Purchased_ID => RegistryItem::AVAILABLE).joins('LEFT OUTER JOIN contributes ON contributes.registry_item_id = registry_items.id').where("contributes.registry_item_id IS NULL")
  scope :not_catalog, joins(:product).where("products.Registrant_ID IS NOT NULL")
  scope :catalog, joins(:product).where("products.Registrant_ID IS NULL")

  scope :recent, order("registry_items.id DESC").where(:IsDeleted => false)

  #-----------------------------
  # Actions
  #-----------------------------
  def delete_from_registry

    # raise "Sorry, you can not delete an item that has been contributed to." if (self.Contributed != 0)

    if self.update_attribute(:IsDeleted, true)
      product = Product.find(self.Product_ID)
      if product.IsKind?
        product.update_attribute(:IsKindView, true)
      end
      return true
    end
    return false
  end

  #-----------------------------
  #  payments
  #-----------------------------
  def total
    MathUtilite.Round2(subtotal + tax_total + shipment_total)
  end

  def subtotal
    MathUtilite.Round2(self.Price.to_f * self.Quantity.to_f)
  end

  def tax_total
    MathUtilite.Round2(self.subtotal * (self.Tax.to_f / 100.0))
  end

  def shipment_total
    MathUtilite.Round2(self.Shipment.to_f *  self.Quantity.to_f)
  end

  def knack_fee (isGetMoney)
    if isGetMoney
      return MathUtilite.Round2(self.Contributed.to_f * Commission::COMMISSIONS.find{|x| x.id == 1}.Percent / 100.0)
    else
      id = self.product.IsKind ? 3 : 2
      percent = Commission::COMMISSIONS.find{|x| x.id == id}.Percent
      return MathUtilite.Round2(self.subtotal * percent / 100)
    end
  end


  #-----------------------------
  # deficient contribute
  #-----------------------------
  def percent
    total = self.total

    if total == 0
      percent = 0
    else
      percent = (total - self.contributed) / total
    end
    return percent
  end

  def deficient_subtotal
    return MathUtilite.Round2(self.subtotal * self.percent)
  end

  def deficient_quantity
    return MathUtilite.Round4(self.Quantity * self.percent)
  end

  def deficient_shipment
    return MathUtilite.Round2(self.Quantity * self.Shipment * self.percent)
  end

  def deficient_tax
    return MathUtilite.Round2(self.subtotal * (self.Tax / 100.0) * self.percent)
  end

  # maximum amount of the contribution
  def deficient_total
    MathUtilite.Round2(deficient_subtotal + deficient_shipment + deficient_tax)
  end

  # maximum amount of the contribution
  def max_contribution
    deficient_subtotal
  end

  # calculate min amount contribute
  def min_contribution
    MathUtilite.Round2(self.max_contribution < MIN_CONTRIBUTE ? self.max_contribution : MIN_CONTRIBUTE)
  end

  # maximum quantity
  def max_quantity
    deficient_quantity
  end

  # min quantity
  def min_quantity
    MathUtilite.Round4(self.max_quantity < MIN_QUANTITY ? self.max_quantity : MIN_QUANTITY)
  end


  #-----------------------------
  # region contribute
  #-----------------------------

  def allow_contribute?
    self.Quantity == 1 && self.Price >= 200
  end

  def percent_contribute(contribute)
    begin
      total_amount = self.total

      if total_amount == 0
        return 0.0
      else
        return contribute.to_f / total_amount
      end

    rescue
      return 0.0
    end

  end

  def quantity_for_contribution(contribute)
    begin
      return MathUtilite.Round4( self.Quantity * (contribute.to_f/self.subtotal.to_f))
    rescue
      return 0.0
    end
  end

  def quantity_for_total(total)
    begin
      return MathUtilite.Round4( self.Quantity * (total.to_f/self.total.to_f))
    rescue
      return 0.0
    end
  end

  # -------------------
  #
  #-----------------------------

  def get_order_number
    o2r2p = self.orders2registry_items.find_all do |e|
      !e.IsGetMoney
    end
    unless o2r2p.blank?
      return o2r2p[0].order.id
    else
      return nil
    end
  end

  def write_main_image
    self.product.write_main_image
  end

  def contributed
    self.Contributed
  end

  def get_product_params
    product_params = Hash.new
    self.product_params2orders.each do |p|
      product_param = self.product.product_params.find_all {|pp| pp.Name == p.Name}.first
      unless product_param.blank?
        value = product_param.value_params.find_all {|vp| vp.Value == p.Value }.first
        unless value.blank?
          product_params[product_param.Name] = value.id
        end
      end
    end

    product_params
  end

  def delete_params
    self.product_params2orders.each do |p|
      ProductParams2order.delete(p.id)
    end
  end

  def reset_params(new_params)
    self.delete_params
    unless new_params.blank?
      new_params.each do |key, value|
        value_param = ValueParam.find(value)
        pp = ProductParams2order.new(:Name => key, :Value => value_param.Value, :registry_item_id => self.id )
        pp.save
      end
    end
  end

  def duplicate(registrant)
    if self.product.catalog?
      prd = self.product
    else
      prd = Product.new({
          :creator => registrant,
          :Description => self.product.Description,
          :ext_color => self.product.ext_color,
          :ext_size=> self.product.ext_size,
          :ext_other => self.product.ext_other,
          :external => self.product.external,
          :MasterPrice => self.product.MasterPrice,
          :SalesPrice => self.product.SalesPrice,
          :Name => self.product.Name,
          :source_name => self.product.source_name,
          :source_url => self.product.source_url})

      # Copy the old images
      prd.main_product_thumb = self.product.main_product_thumb
      prd.main_product_image = self.product.main_product_image

    end


    new_item = RegistryItem.new({
                                    :Purchased_ID => AVAILABLE,
                                    :product => prd,
                                    :registrant => registrant,
                                    :color => self.color,
                                    :copied_from => self,
                                    :IsToolbar => self.IsToolbar,
                                    :Price => self.Price,
                                    :Shipment => self.Shipment,
                                    :Tax => self.Tax,
                                    :Quantity => self.Quantity})

  end

  def order_by_registrant
    self.orders.each { |order|
      if order.order_type != Order::CONTRIBUTE
        return order
      end
    }
    nil
  end

  def section_order
    section.order
  end

  def section_order=(foo)
  end

  def reject_product_updates(attributed)
    #No need to check if a new product is being created
    if attributed["id"]
      prod = Product.find(attributed["id"])
      return true unless prod.cash?
    end
    #logger.error "Here are the keys"
    #attributed.keys.each do |key|
    #  logger.error key + " "
    #end
    (attributed.keys - ["id", "Name", "Description", "MasterPrice", "source_name", "source_url", "external", "ext_color", "ext_other", "ext_size", "main_product_image", "stock_image"]).length > 0
  end

  def self.get_feed_items(filter = "All", registrant = nil, site = nil)
    case filter
      when "friends"
        relationship = RegistryItem.recent.where(:Registrant_ID => registrant.follows.map{|i| i.followed_id})
      when "me"
        relationship = RegistryItem.recent.where(:Registrant_ID => registrant.id)
      else
        relationship = RegistryItem.recent
    end
    if site
      relationship = relationship.joins(:product).where(:product => {:source_name => site})
    end
    return relationship.includes({:product => :stores}, :registrant, {:copied_from => :registrant})
  end

  def update_for_added_contribution(cont)
    self.Contributed += cont.Contribute unless cont.external?
    self.Purchased_ID = RegistryItem::PURCHASED if self.contributed >= (self.total - 0.10)
  end

  def update_for_deleted_contribution(cont)
    self.Contributed -= cont.Contribute unless cont.external?
    self.contributes.delete(cont)
    self.Purchased_ID = RegistryItem::AVAILABLE if self.contributed < (self.total - 0.10)
  end

  def update_for_changed_contribution(cont)
    raise "Can not modify a cash contribution once it has been made" unless cont.external?
    self.reload
    self.Purchased_ID = self.contributed < (self.total - 0.10) ? RegistryItem::AVAILABLE : RegistryItem::PURCHASED
  end

  def increase_contributed(amount)
    update_attributes(:Contributed => self.Contributed + amount)
  end

  def fully_paid_for?
    self.subtotal < self.Contributed
  end

  protected
  def set_default_section
    if self.section.nil? || self.section.registrant_id != self.Registrant_ID
      self.section = self.registrant.sections.first
      self.order = nil
    end
  end

end
