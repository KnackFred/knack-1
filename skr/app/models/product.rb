class Product < ActiveRecord::Base
  has_many :products2categories, :foreign_key => "Product_ID"
  has_many :categories, :through => :products2categories

  belongs_to :shipment_category, :foreign_key => "ShipmentCategory_ID", :class_name => "Category"

  has_many :products2colors, :foreign_key => "Product_ID"
  has_many :colors, :through => :products2colors

  has_many :products2stores, :foreign_key => "Product_ID"
  has_many :stores, :through => :products2stores

  has_many :registry_items, :foreign_key => "Product_ID"
  has_many :registrants, :through => :registry_items
  belongs_to :creator, :foreign_key => "Registrant_ID", :class_name => "Registrant"

  has_many :orders2products, :foreign_key => "Product_ID"
  has_many :orders, :through => :orders2products

  has_many :product_params

  belongs_to :brand, :foreign_key => "Brand_ID"

  has_many :product_images
  has_many :product_attachments

  accepts_nested_attributes_for :product_images, :allow_destroy => true
  accepts_nested_attributes_for :product_attachments, :allow_destroy => true

  attr_writer :BrandType
  def BrandType
    @BrandType || 1
  end
  attr_accessor :BrandName
  attr_accessor :templates

  validates     :Name,
                        :presence => true,
                        :length => {
                                    :minimum => 0,
                                    :maximum => 50,
                                    :message => "is too long (maximum is 50 characters)"
                                    }
  validates     :MasterPrice,
                        :presence => true,
                        :numericality => {:greater_than_or_equal_to => 0}
  validates     :SalesPrice,
                        :numericality => {
                                          :greater_than_or_equal_to => 0,
                                          :if => Proc.new { |p| !p.SalesPrice.blank? }
                                          }
  validates     :ProductStatus_ID,
                        :presence => true,
                        :numericality =>
                                          {:only_integer => true,
                                          :greater_than_or_equal_to => 1,
                                          :less_than_or_equal_to => 3
                                          }
  validate      :validate_stores
  validate      :validate_categories

  validates     :Brand_ID,
                        :numericality => {
                                          :only_integer => true,
                                          :greater_than_or_equal_to => 1,
                                          :allow_nil => true
                                          }
  validates     :ShipmentCategory_ID,
                        :if => Proc.new { |p| p.catalog? && p.ShipmentType.to_i == STANDARD },
                        :presence => true,
                        :numericality => {
                                          :only_integer => true,
                                          :greater_than_or_equal_to => 1,
                                          :allow_nil => true,
                                          :message => "no category selected"
                        }
  validates     :ShipmentCost,
                        :presence => {:if => Proc.new { |p| (p.catalog? && p.ShipmentType.to_i == CUSTOM)}},
                        :numericality => {
                                          :greater_than_or_equal_to => 0,
                                          :allow_nil => true
                                          }

  validates     :Description,
                        :presence => {:if => Proc.new {|p| p.Description.nil?}},
                        :length => {
                                    :minimum => 0,
                                    :maximum => 900,
                                    :message => "is too long (maximum is 900 characters)"
                                   }

  validates     :source_url, :presence => true, :if => :external?
  validates     :source_url, :length => { :maximum => 1024 }

  validates     :source_name, :presence => true, :if => :external?
  validates     :source_name, :length => {:maximum => 50}

  validates     :ext_color, :length => {:maximum => 50}
  validates     :ext_size, :length => {:maximum => 50}
  validates     :ext_other, :length => {:maximum => 100}

  STANDARD = 1
  CUSTOM = 2
  FREE = 3
  SHIPMENT_TYPES = {STANDARD => "Standard", CUSTOM => "Oversize", FREE => "Free"}
  validates     :ShipmentType,
                  :inclusion => {:in => SHIPMENT_TYPES}

  validates     :priority,
                        :numericality => {
                                    :only_integer => true,
                                    :greater_than_or_equal_to => 0,
                                    }

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :stock_image

  before_save :set_product_thumb
  after_update :reprocess_product_thumb, :if => :cropping?
  before_validation :set_stock_image, :unless => "stock_image.blank?"
  before_validation :set_shipment_cost

  has_attached_file :main_product_thumb,
                    :default_url => "/images/defaultImage.png",
                    :styles => {:small => ["105x79", :jpg],
                                :medium => ["161x121", :jpg],
                                :for_crop => ["400x300", :jpg]},
                    :convert_options => {:small => "-background white -gravity center -extent 104x78 -strip -quality 80",
                                         :medium => "-background white -gravity center -extent 160x120 -strip -quality 80",
                                         :for_crop => "-background white -gravity center -strip -quality 80"},
                    :processors => [:cropper]

  has_attached_file :main_product_image,
                    :default_url => "/images/defaultImage.png",
                    :styles => {:small => ["52x52^", :jpg],
                                :large => ["370", :jpg]},
                    :convert_options => {:small => "-background white -gravity center -extent 52x52 -strip -quality 80",
                                         :large => "-background white -strip -quality 80"}

  validates_attachment_presence :main_product_image
  validates_attachment_content_type :main_product_image, :content_type => %w(image/jpg image/jpeg image/png image/gif)
  validates_attachment_size :main_product_image, { :in => 0..3.megabytes }

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def ratio_x
    Paperclip::Geometry.from_file(main_product_thumb.path(:original)).width / Paperclip::Geometry.from_file(main_product_thumb.path(:for_crop)).width
  end

  def ratio_y
    Paperclip::Geometry.from_file(main_product_thumb.path(:original)).height / Paperclip::Geometry.from_file(main_product_thumb.path(:for_crop)).height
  end

  define_index do
    indexes :Description
    indexes :Name, :sortable => true
    indexes brand.Name, :as => :Brand
    has "IFNULL(products.SalesPrice, products.MasterPrice)", :as => :current_price, :type => :float
    has :count_view
    has :priority
    set_property :field_weights => {
      :Name => 10,
      :Brand => 5,
      :Description => 1
    }
    where "products.Registrant_ID IS NULL AND products.IsDeleted = 0 AND products.IsKindView = 1 AND products.ProductStatus_ID = #{ProductStatus::STATUSES.invert['Available']}"
  end

  define_index 'name_and_brand' do
    indexes :Name, :sortable => true
    indexes brand.Name, :as => :Brand
    has "IFNULL(products.SalesPrice, products.MasterPrice)", :as => :current_price, :type => :float
    has :count_view
    has :priority
    set_property :field_weights => {
        :Name => 10,
        :Brand => 5,
    }
    where "products.Registrant_ID IS NULL AND products.IsDeleted = 0 AND products.IsKindView = 1 AND products.ProductStatus_ID = #{ProductStatus::STATUSES.invert['Available']}"
  end

  #-----------------------------------------------
  # Getting product status
  #-----------------------------------------------
  def product_status
    ProductStatus.new do |p|
      p.id = self.ProductStatus_ID
      p.Name = ProductStatus::STATUSES[self.ProductStatus_ID]
    end
  end

  #-----------------------------------------------
  # Getting current price
  #-----------------------------------------------
  def Price
    self.SalesPrice.blank? ? self.MasterPrice : self.SalesPrice
  end

  #-----------------------------------------------
  # Is product on sale?
  #-----------------------------------------------
  def is_sales?
    !self.SalesPrice.blank?
  end

  #-----------------------------------------------
  # Getting Shipment
  #-----------------------------------------------
  def Shipment
    case self.ShipmentType
      when Product::STANDARD
        if self.shipment_category
          self.shipment_category.per_shipment
        else
          0.0
        end
      when Product::CUSTOM
        self.ShipmentCost
      when Product::FREE
        0.0
    end
  end

  #-----------------------------------------------
  # Getting partner id
  #-----------------------------------------------
  def get_partner_id
    self.stores.blank? ? nil : self.stores.first.partner.id
  end

  #-----------------------------------------------
  # Getting default store
  #-----------------------------------------------
  def get_default_store
    self.stores.blank? ? nil : Store.where(:PartnerID => self.get_partner_id, :IsDefault => true).first
  end

  #-----------------------------------------------
  # Getting tax rate for the product
  #-----------------------------------------------
  def tax(state_id)
    default_store = self.get_default_store
    unless default_store.blank?
      if default_store.State_ID == state_id.to_i
        return default_store.state.GeneralTax.to_f
      end
    end
    return 0.0
  end

  #-----------------------------------------------
  # Is cash
  #-----------------------------------------------
  def cash?
    !self.Registrant_ID.nil?
  end

  #-----------------------------------------------
  # catalog?
  #-----------------------------------------------
  def catalog?
    self.Registrant_ID.nil?
  end

  #-----------------------------------------------
  # unique?
  #-----------------------------------------------
  def unique?
    self.IsKind?
  end

  #-----------------------------------------------
  # available?
  # Indicates if the item is available to purchase or add to registry.
  # Note that an item may be purchased even if it is no longer available.  For instance I may have added it to my registry before it was deleted
  #-----------------------------------------------
  def available?
    (self.IsDeleted == false &&
        self.ProductStatus_ID == ProductStatus::AVAILABLE &&
        (self.IsKind? ? self.IsKindView? : true)) || !catalog?
  end

  #-----------------------------------------------
  # Getting category (THIS IS ACTUALLY KIND OF GET SHIPPING CATEGORY)
  #-----------------------------------------------
  def get_category
    case self.ShipmentType
      when Product::STANDARD
        if self.ShipmentCategory_ID
          return Category.find_by_id(self.ShipmentCategory_ID)
        end
    end

    unless self.categories.blank?
      return self.categories.first
    end

    return nil
  end

  #-----------------------------------------------
  # Check local
  #-----------------------------------------------
  def local?(registrant = nil)

    if registrant
      self.stores.each do |store|
        return true if store.State_ID == registrant.State_ID
      end
    end

    return false
  end

  #-----------------------------------------------
  # Find products by entry name
  #-----------------------------------------------
  def self.search_by_name_and_brand(text = '', limit = 20)
    Product.search text,
        :index => 'name_and_brand_core',
                  :page => 1,
                  :per_page => limit,
                  :match_mode => :any
  end

  #-----------------------------------------------
  # Getting knack fee price for product
  #-----------------------------------------------
  def knack_fee
    id = self.IsKind ? 3 : 2
    percent = Commission::COMMISSIONS.find{|x| x.id == id}.Percent
    MathUtilite.Round2(self.Price * percent / 100)
  end

  #-----------------------------------------------
  # Getting total amount for product
  #-----------------------------------------------
  def total(quantity, state_id)
    return MathUtilite.Round2((self.Price.to_f + (self.Price.to_f * (self.tax(state_id)/100)) + self.Shipment) * quantity)
  end

  #-----------------------------------------------
  # Getting name for url
  #-----------------------------------------------
  def name_url
    CGI::escape(self.Name.gsub('/', ''))
  end

  #-----------------------------------------------
  # Getting all products visible in the catalog
  #-----------------------------------------------
  def self.find_all_view_catalog(text = '', params = nil, category_ids = nil)
    if text.blank?
      query = Product.get_query_find_products(text, params, category_ids).group('products.id')
      if params
        if params.max_price > 0
          query = query.where('IFNULL(products.SalesPrice, products.MasterPrice) >= ? AND IFNULL(products.SalesPrice, products.MasterPrice) <= ?', params.min_price, params.max_price )
        end
        query = query.paginate(:page => params.page, :per_page => params.per_page).order(:priority.desc, :count_view.desc)
      end
      query.select("products.id, products.Name, products.MasterPrice, products.Name, products.SalesPrice, products.main_product_thumb_file_name, products.main_product_thumb_updated_at, products.main_product_thumb_file_size, products.main_product_thumb_content_type")
    else
      if params.max_price > 0
        query = Product.search text, :page => params.page, :per_page => params.per_page, :match_mode => :any, :with => {:current_price => params.min_price.to_f..params.max_price.to_f}
      else
        query = Product.search text, :page => params.page, :per_page => params.per_page, :match_mode => :any
      end
    end
  end

  #-----------------------------------------------
  # Getting count products visible in the catalog
  #-----------------------------------------------
  def self.get_count_products(text = '', params = nil, category_ids = nil, join_categories = false)
    if text.blank?
      query = Product.get_query_find_products(text, params, category_ids)
      if params
        if params.max_price > 0
          query = query.where('IFNULL(products.SalesPrice, products.MasterPrice) >= ? AND IFNULL(products.SalesPrice, products.MasterPrice) <= ?', params.min_price, params.max_price )
        end
      end
      if join_categories
        query = query.joins(:products2categories)
      end
      query.select('DISTINCT products.id').count
    else
      if params.max_price > 0
        query = Product.search_count text, :page => params.page, :per_page => params.per_page, :match_mode => :any, :with => {:current_price => params.min_price.to_f..params.max_price.to_f}
      else
        query = Product.search_count text, :page => params.page, :per_page => params.per_page, :match_mode => :any
      end
    end
  end

  #-----------------------------------------------
  # Getting all products visible in the catalog
  #-----------------------------------------------
  def self.get_product_prices(text = '', params = nil, category_ids = nil)
    if text.blank?
      query = Product.get_query_find_products(text, params, category_ids)
      query.select('IFNULL(products.SalesPrice, products.MasterPrice) as current_price').group(:current_price).order('current_price').collect(&:current_price)
    else
      query = Product.search text,
                  :page => 1,
                  :per_page => 9999999,
                  :group_by => 'current_price',
                  :match_mode => :any
      query.collect{|p| p.sphinx_attributes['current_price']}.sort
    end
  end

  #-----------------------------------------------
  # Getting query for find products
  #-----------------------------------------------
  def self.get_query_find_products(text = '', params = nil, category_ids = nil)
    query = Product.where(:IsDeleted => false,
                          :IsKindView => true,
                          :ProductStatus_ID => ProductStatus::STATUSES.invert['Available'],
                          :Registrant_ID => nil)
    if category_ids
      query = query.joins(:products2categories).where(:products2categories => {:Category_ID => category_ids})
    end
    if params
      if params.param
        case params.param
           when "b"
             then
             query = query.where(:Brand_ID => params.param_value)
           when "s"
             then
             query = query.joins(:products2stores).where(:products2stores => {:Store_ID => params.param_value})
        end
      end
    end
    query
  end

  #-----------------------------------------------
  # Getting query for find products for the Admin and Partner Experiences
  #-----------------------------------------------
  def self.get_query_find_products_for_partner(filter_product)
    query = Product.select('products.id, products.brand_ID, products.Registrant_ID, products.ShipmentCategory_ID, products.Description, products.IsDeleted, products.IsKind, products.IsKindView, products.MasterPrice, products.Name, products.PartnerProduct_ID, products.priority, products.ProductStatus_ID, products.SalesPrice, products.ShipmentCost, products.ShipmentType, count(distinct orders2registry_items.id) + count(distinct orders2products.id) as ordered, count(distinct sel.id) as selected, count(distinct purchase.id) as purchased, IFNULL(products.SalesPrice, products.MasterPrice) as current_price, GROUP_CONCAT(distinct store.Name SEPARATOR ", ") as store_names, GROUP_CONCAT(distinct category.Name SEPARATOR ", ") as category_names')

    query = query.joins(:registry_items.outer)
    query = query.joins('left join registry_items as purchase on products.id = purchase.Product_ID and purchase.Purchased_ID = 1')
    query = query.joins('left join registry_items as sel on products.id = sel.Product_ID and sel.Purchased_ID = 2')
    query = query.joins('left join products2stores as p2s on products.id = p2s.Product_ID')
    query = query.joins('left join stores as store on store.id = p2s.Store_ID')
    query = query.joins('left join products2categories as p2c on products.id = p2c.Product_ID')
    query = query.joins('left join categories as category on category.id = p2c.Category_ID')
    query = query.joins(:orders2products.outer)
    query = query.joins('left join orders2registry_items on orders2registry_items.registry_item_id = registry_items.id and orders2registry_items.Contribute_ID IS NULL AND orders2registry_items.IsGetMoney = 0 AND orders2registry_items.IsDeleted = 0')

    # find by id
    query = query.where(:products => {:id => filter_product.id}) unless filter_product.id.blank?

    # find by product_status_id
    query = query.where(:products => {:ProductStatus_ID => filter_product.product_status_id}) unless filter_product.product_status_id.to_s == "0"

    # find by product_type_id
    query = query.where(:products => {:Registrant_ID => nil}) if (filter_product.product_type_id == "1")
    query = query.where("products.Registrant_ID IS NOT NULL") if (filter_product.product_type_id == "2")

    # find by title
    query = query.where(:products => {:Name.matches => "%#{filter_product.title}%"}) unless filter_product.title.blank?

    # find by category
    query = query.joins(:products2categories).where(:products2categories => {:Category_ID => filter_product.category_id}) unless filter_product.category_id == Category.root.id || filter_product.category_id.to_s == "0"

    # find by partner
    query = query.joins(:stores).where(:stores => {:PartnerID => filter_product.partner_id}) unless filter_product.partner_id.to_s == "0"

    # find by store
    query = query.joins(:stores).where(:stores => {:id => filter_product.store_id}) unless filter_product.store_id.to_s == "0"

    query = query.group("products.id")

    # sort by field
    query = query.order("#{filter_product.sort_field} #{FilterProduct::SORT_DIRECTION[filter_product.sort_direction.to_s]}") unless filter_product.sort_field.blank?

    query = query.order(:id.desc).paginate(:page => filter_product.page, :per_page => filter_product.per_page)

    filter_product.page = 1 if filter_product.page.to_i > 1 && query.length == 0

    query.order(:id.desc).paginate(:page => filter_product.page, :per_page => filter_product.per_page)
  end

  #-----------------------------------------------
  # Getting count all products visible in the catalog
  #-----------------------------------------------
  def self.get_count_view_catalog(category_ids = nil)
    query = Product.where(:IsDeleted => false, :IsKindView => true, :ProductStatus_ID => ProductStatus::STATUSES.invert['Available'], :Registrant_ID => nil)
    if category_ids
      query = query.joins(:products2categories).where(:products2categories => {:Category_ID => category_ids})
    end
    query.select('DISTINCT products.id').count
  end

  #-----------------------------------------------
  # Getting count Selected for product
  #-----------------------------------------------
  def Selected
    RegistryItem.where(:IsDeleted => false, :Purchased_ID => RegistryItem::AVAILABLE, :Product_ID => self.id).count
  end

  #-----------------------------------------------
  # Getting count Purchased for product
  #-----------------------------------------------
  def Purchased
    RegistryItem.where(:IsDeleted => false, :Purchased_ID => RegistryItem::PURCHASED, :Product_ID => self.id).count
  end

  #-----------------------------------------------
  # Getting count Ordered for product
  #-----------------------------------------------
  def Ordered
    count = 0
    count += self.orders2products.count
    count += Orders2registryItem.where(:IsDeleted => false, :Contribute_ID => nil, :IsGetMoney => 0).joins(:registry_item).where(:registry_item => {:Product_ID => self.id}).count
    return count
  end

  #-----------------------------------------------
  # Get all product images
  #-----------------------------------------------
  def all_product_images
    imgs = [self.main_product_image]
    self.product_images.each do |img|
      imgs << img.product_image
    end
    imgs
  end

  def set_params(new_params)
    # Delete params that no longer exist
    self.product_params.each do |p|
      unless (new_params.list.detect { |l| l.id.to_s == p.id.to_s})
        p.destroy
      end
    end

    # Create ot update existing params
    new_params.list.each do |p|
      product_param = ProductParam.find_by_id(p.id)

      if product_param.blank?
        product_param = ProductParam.new(:Name => p.name,
                                         :IsTemplate => p.is_template,
                                         :Product_ID => self.id,
                                         :Partner_ID => self.stores.first.partner.id)
        if product_param.save
          p.list_values.each do |v|
            ValueParam.create(:Value => v, :ProductParam_ID => product_param.id)
          end
        end
      else
        product_param.update_attributes(:Name => p.name,
                                        :IsTemplate => p.is_template)

        product_param.delete_values

        p.list_values.each do |v|
          ValueParam.create(:Value => v, :ProductParam_ID => product_param.id)
        end
      end
    end
  end

  protected
  def set_stock_image

    path = "#{Rails.root}/public/images/stocks/stock#{stock_image}.png"
    file = File.open(path, 'rb')
    self.main_product_image = file
  end

  def reprocess_product_thumb
    self.main_product_thumb.reprocess!
  end

  def set_product_thumb
    self.main_product_thumb = self.main_product_image if self.main_product_image_updated_at_changed? && !cropping?
  end

  def small_thumb_url
    self.main_product_thumb.url(:small)
  end

  def validate_stores
    errors.add(:stores, "You must specify a store") if stores.size == 0 && catalog?
  end

  def validate_categories
    errors.add(:categories, "You must specify a category") if categories.size == 0 && catalog?
  end

  def set_shipment_cost()
    case self.ShipmentType
      when Product::STANDARD
        self.ShipmentCost = nil
      when Product::FREE
        self.ShipmentCost = 0
      else
    end
  end

end