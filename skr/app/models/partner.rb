class Partner < ActiveRecord::Base

  has_many :stores, :foreign_key => "PartnerID"
  has_one :default_store, :class_name => "Store", :foreign_key => "PartnerID", :conditions => "IsDefault"

  has_many :partner_administrators

  attr_accessor :Password_confirmation
  attr_accessor :static_products

  has_many :product_params
  has_many    :knack_payments, :foreign_key => "Partner_ID"

  validates :Email,               :presence => true,
                                  :length => {:minimum => 0, :maximum => 30},
                                  :email_format => {:message => "email must be valid"},
                                  :uniqueness => {:message => "This email is already in use", :case_sensitive => false}

  validates :AgreeWithSitePolicy, :presence => {:message => "Confirm agree with site police"},
                                  :on => :create

  validates :BillingName,         :presence => true,
                                  :length => {:minimum => 0, :maximum => 50}

  validates :BillingLastName,     :presence => true,
                                  :length => {:minimum => 0, :maximum => 50}

  validates :BillingEmail,
                                  :length => {:minimum => 0, :maximum => 50},
                                  :email_format => {:message => "email must be valid"},
                                  :on => :update

  validates :BillingStreet,
                                  :length => {:minimum => 0, :maximum => 50},
                                  :on => :update

  validates :BillingCity,         :presence => true,
                                  :length => {:minimum => 0, :maximum => 50},
                                  :on => :update

  validates :Description,         :length => {:minimum => 0, :maximum => 900}

  validates :BillingState_ID,     :presence => true,
                                  :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :message => "not select state"},
                                  :on => :update

  validates :BillingZIP,          :presence => true,
                                  :zip_format => {:message => 'zip must be valid'},
                                  :on => :update

  validates :BillingPhone,        :length => {:minimum => 6, :maximum => 25},
                                  :phone_format => {:message => "You must provide a valid Phone"},
                                  :allow_blank => true


  validates_presence_of :Password_confirmation, :Password, :on => :create
  validates_confirmation_of :Password, :on => :create, :message => "Password Is not the same"

  validates_length_of :Password, :on => :create, :within => 5..20

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_logo, :if => :cropping?
  before_create :set_defaults
  before_validation :delete_space

  has_attached_file :logo,
                    :default_url => "/images/defaultImage.png",
                    :styles => {:small => ["169x127", :png],
                                :medium => ["193x145", :png],
                                :for_crop => ["400x300", :png]},
                    :convert_options => {:small => "-gravity center -extent 168x126 -strip -quality 7",
                                         :medium => "-gravity center -extent 192x144 -strip -quality 7",
                                         :for_crop => "-gravity center -strip -quality 7"},
                    :processors => [:cropper]

  validates_attachment_content_type :logo, :content_type => %w(image/jpg image/jpeg image/png)
  validates_attachment_size :logo, { :in => 0..3.megabytes }

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def ratio_x
    Paperclip::Geometry.from_file(logo.path(:original)).width / Paperclip::Geometry.from_file(logo.path(:for_crop)).width
  end

  def ratio_y
    Paperclip::Geometry.from_file(logo.path(:original)).height / Paperclip::Geometry.from_file(logo.path(:for_crop)).height
  end

  def self.check(email, password)
    partner = Partner.find_by_Email_and_IsDeleted(email, false)
    if partner.blank? || !PasswordUtilities.check(password, partner.Password) || !partner.IsActivated
       #raise 'Invalid login or password'
       return nil
		end
		partner
  end

  def orders
    orders_array = Array.new
    self.stores.each do |s|
      orders_array += s.orders
    end

    array = Array.new
    orders_array = orders_array.group_by(&:id)

    orders_array.each do |o|
      order = o[1][0]
      if order.order_type == Order::BUY
        array << order
      end
    end

    return array
  end

  def get_count_products
#    count = 0
#    self.stores.each do |s|
#      count += s.products.length
#    end
    #return 0
    return self.get_partner_products.length
  end

  def get_partner_products
    unless self.static_products.blank?
      return self.static_products
    end
    tmp_products = Array.new
    self.stores.each do |s|
      tmp_products += s.products
    end
    tmp_products = tmp_products.group_by { |p| p.id.to_i }

    products = Array.new

    tmp_products.each do |p|
      unless p[1][0].IsDeleted
        products << p[1][0]
      end
    end

    self.static_products = products
    return products
  end

  def get_count_selected
    #return 0
    products = self.get_partner_products

    count = 0
    products.each do |p|
      count += (RegistryItem.find(:all, :conditions => ["Product_ID = ? AND Purchased_ID = 2 AND IsDeleted = 0", p.id])).length
    end

    return count
  end

  def get_count_purchased
    products = self.get_partner_products

    count = 0
    products.each do |p|
      count += (RegistryItem.find(:all, :conditions => ["Product_ID = ? AND Purchased_ID = 1 AND IsDeleted = 0", p.id])).length
    end

    return count
  end

  def get_count_ordered
    count = 0
    self.orders.each do |o|
      count += o.get_partner_orders2product(self.id).length
      count += o.get_partner_orders2registrant2product(self.id).length
    end

    return count
  end

  def get_default_store
    self.default_store
  end

  #-----------------------------------------------
	# Get Display Name
	#-----------------------------------------------
  def display_name
    if ((self.BillingName.length + self.BillingLastName.length) > 14)
      if self.BillingName.length > 15
        self.BillingName[0..12] + '...'
      else
        self.BillingName
      end
    else
      self.BillingName + ' ' + self.BillingLastName
    end
  end

  protected

  def delete_space
    self.BillingName = self.BillingName ? self.BillingName.strip : nil
    self.BillingLastName = self.BillingLastName ? self.BillingLastName.strip : nil
    self.BillingPhone = self.BillingPhone ? self.BillingPhone.strip : nil
    self.Email = self.Email ? self.Email.strip : nil
    self.Password = self.Password ? self.Password.strip : nil
    self.Password_confirmation = self.Password_confirmation ? self.Password_confirmation.strip : nil
  end

  def set_defaults
    self.ImageGUID ||= ImageUtilities.get_guid
    self.LogoGUID ||= ImageUtilities.get_guid
    file = File.new("#{Rails.root}/public/images/defaultImage.png")
    self.logo = file
    file.close
  end

  def reprocess_logo
    self.logo.reprocess!
  end

end
