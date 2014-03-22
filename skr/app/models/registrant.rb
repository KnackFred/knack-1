class Registrant < ActiveRecord::Base
  has_many :registry_items, :conditions => "registry_items.isDeleted = false", :foreign_key => "Registrant_ID", :order => 'registry_items.order'
  accepts_nested_attributes_for :registry_items

  has_many :products, :through => :registry_items

  has_many :owned_products, :class_name => "Product", :foreign_key => "Registrant_ID"

  has_many :orders

  has_many :withdrawals, :foreign_key => "Registrant_ID"
  belongs_to :state, :foreign_key => "State_ID"

  has_many :sections, :dependent => :destroy, :order => 'sections.order'
  accepts_nested_attributes_for :sections, :allow_destroy => true

  has_many :follows, :dependent => :destroy
  has_many :followed_registrants, :through => :follows, :source => "followed"

  has_many :follow_bys, :class_name => "Follow", :dependent => :destroy
  has_many :followed_by_registrants, :through => :follows_bys, :source => "registrant"

  attr_accessor :change_password
  attr_accessor :old_password
  attr_accessor :new_password

  validates :FirstName, :presence => true,
                        :length => {:minimum => 0, :maximum => 30}
  validates :LastName,  :presence => true,
                        :length => {:minimum => 0, :maximum => 30}
  validates :Email,     :presence => true,
                        :length => {:minimum => 0, :maximum => 60},
                        :email_format => true,
                        :uniqueness => {:message => "This email is already in use", :case_sensitive => false}
  validates :EventDate,
                        :date_format => {:if => Proc.new { |p| p.EventDate == ''}}

  validates :new_password,
                        :presence => {:on => :create},
                        :length => {:minimum => 6, :maximum => 20, :on => :create}
  validates_length_of :new_password, :within => 6..20, :on => :update, :if => "change_password == '1'"


  validates :City,
                        :length => {:minimum => 0, :maximum => 50}
  validates :State_ID,
                        :presence => {:message => "State is not selected."},
                        :numericality => {:only_integer => true, :greater_than => 0, :message => "State is not selected."}
  validates :ZIP,
                        :zip_format => {
                                    :message    => 'You must provide a valid ZIP.',
                                    :allow_nil => :true},
                        :unless => Proc.new { |a| a.ZIP.blank? }

  validates :RegistryType_ID,
                        :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true}
  validates :FirstNameCoCreated,
                        :length => {:minimum => 0, :maximum => 30}
  validates :LastNameCoCreated,
                        :length => {:minimum => 0, :maximum => 30}
  validates :Address,
                        :length => {:minimum => 0, :maximum => 50}

  validates :PhoneNumber,
                        :length => {:minimum => 0, :maximum => 20}
  validates :EventLocation,
                        :length => {:minimum => 0, :maximum => 150}
  validates :Description,
                        :length => {:minimum => 0, :maximum => 600}

#  validates_format_of   :EventDate,
#                        :with       => /^([0-9]{2}).([0-9]{2}).([0-9]{4})$/i,
#                        :message    => 'Event Date must be valid'


  before_validation :delete_space
  before_update :do_password_change
  before_create :do_password_set
  after_find :set_default_section
  before_create :set_defaults

  scope :invited, :conditions => ['is_invited = ?', true]
  scope :not_invited, :conditions => ['is_invited = ?', false]
  scope :active, :conditions => ['IsDeleted = ?', false]

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_profile_pic, :if => :cropping?

  has_attached_file :profile_image,
                    :styles => {:small => ["121x91", :png],
                                :medium => ["191x144", :png],
                                :large => ["249x187", :png],
                                :for_crop => ["400x300", :png]},
                    :convert_options => {:small => "-gravity center -extent 120x90 -strip -quality 7",
                                         :medium => "-gravity center -extent 190x143 -strip -quality 7",
                                         :large => "-gravity center -extent 248x186 -strip -quality 7",
                                         :for_crop => "-gravity center -strip -quality 7"},
                    :processors => [:cropper]

  validates_attachment_content_type :profile_image, :content_type => %w(image/jpg image/jpeg image/png)
  validates_attachment_size :profile_image, { :in => 0..3.megabytes }

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def ratio_x
    Paperclip::Geometry.from_file(profile_image.path(:original)).width / Paperclip::Geometry.from_file(profile_image.path(:for_crop)).width
  end

  def ratio_y
    Paperclip::Geometry.from_file(profile_image.path(:original)).height / Paperclip::Geometry.from_file(profile_image.path(:for_crop)).height
  end


  #-----------------------------------------------
  # Checks credentials against the database and either logs the user in,
  # or throws an exception
  #-----------------------------------------------
  def self.sign_in(email, password)
    registrant = Registrant.where(:Email => email.strip, :IsDeleted => false).first()

    if registrant.nil?
      raise 'Invalid login or password'
    end

    unless registrant.fbuid.blank? || Rails.env.development?
      raise 'Please log-in using the Facebook log-in button.'
    end

    unless PasswordUtilities.check(password.strip, registrant.Password)
      raise 'Invalid login or password'
    end

    registrant.increment!(:Logins)
    registrant
  end

  #-----------------------------------------------
  # Attempts to sign the user in using a secret code..
  #-----------------------------------------------
  def self.sign_in_remember_me(id, code)
    registrant = Registrant.where(:id => id, :IsDeleted => false).first()
    if registrant.blank? || (registrant.secret_code != code )
      return nil
    end

    registrant.increment!(:Logins)
    registrant
  end

  #-----------------------------------------------
  # Checks credentials against the database and either logs the user in,
  # or throws an exception
  #-----------------------------------------------
  def self.sign_in_fb(fbuid)
    registrant = Registrant.where(:fbuid => fbuid, :IsDeleted => false).first()

    if fbuid.nil? || registrant.nil?
      raise 'User Not Found'
    end

    registrant.increment!(:Logins)
    registrant
  end

  #-----------------------------------------------
  # Attempts to sign the user in using a GUID.  BELIEVED TO BE NO LONGER REQUIRED
  #-----------------------------------------------
#  def self.sign_in_guid(guid)
#    registrant = Registrant.where("ImageGUID = ? AND IsDeleted = 0 AND IsActivated = 1", uid).first()
#
#    if !registrant.blank?
#      registrant.update_attribute(:Logins, registrant.Logins.to_i + 1)
#    end
#
#    registrant
#  end

  #-----------------------------------------------
  # Gets the secret code (Used for remember me) for this user'.
  #-----------------------------------------------
  def secret_code()
    Digest::SHA1.hexdigest( self.Email )[4,18]
  end

  #-----------------------------------------------
  # Check for facebook if email already exists
  #-----------------------------------------------
  def self.email_exists(email)
    if email.nil?
      return nil
    end
    return Registrant.find_by_Email_and_IsDeleted(email.strip, false)
  end

  #-----------------------------------------------
  # Check if facebook user already exists
  #-----------------------------------------------
  def self.fb_exists(fbuid)
    return Registrant.find_by_fbuid_and_IsDeleted(fbuid, false)
  end

  #-----------------------------------------------
  # Attempt to activate the user based on the guid.
  #-----------------------------------------------
  def self.activate(guid)
    registrant = Registrant.where(:ImageGUID => guid, :IsDeleted => false).first()

    if registrant.blank? || registrant.IsActivated
      return nil
    end

    registrant.update_attribute(:IsActivated, 1)
    registrant
  end

  #-----------------------------------------------
  # Resets the password to a system defined value
  #-----------------------------------------------
  def reset_password()
    new_pwd = PasswordUtilities.generate_new
    self.update_attributes(:Password => PasswordUtilities.hash(new_pwd))
    new_pwd
  end

  #-----------------------------------------------
  # MANAGE REGISTRY METHODS.
  #-----------------------------------------------

  def gifts (type = nil, page = 1, per_page = 999999, sort_id = 0)
    #Filter Based on Type
    unless type.nil? || type == 0
      query = RegistryItem.where(:Registrant_ID => self.id, :IsDeleted => false, :Purchased_ID => type)
    else
      query = RegistryItem.where(:Registrant_ID => self.id, :IsDeleted => false)
    end

    #Apply the sort order
    case sort_id
    when 1
      query.order("PRICE * QUANTITY ASC").paginate(:page => page, :per_page => per_page)
    when 2
      query.order("PRICE * QUANTITY DESC").paginate(:page => page, :per_page => per_page)
    else
      query.order("UPDATED_AT DESC").paginate(:page => page, :per_page => per_page)
    end

  end

  def gifts_count (type = nil)
    unless type.nil?
      return RegistryItem.where(:Registrant_ID => self.id, :IsDeleted => false, :Purchased_ID => type).count()
    else
      return RegistryItem.where(:Registrant_ID => self.id, :IsDeleted => false).count()
    end
  end

  def get_queue
    return self.Cash + RegistryItem.where("Registrant_ID = ? AND Purchased_ID != 3", self.id).sum(:Contributed)
  end

  def get_count_selected
    return self.registry_items.where(:IsDeleted => false, :Purchased_ID => RegistryItem::AVAILABLE).count
  end

  def get_count_purchased
    return self.registry_items.where(:IsDeleted => false, :Purchased_ID => RegistryItem::PURCHASED).count
  end

  def get_count_ordered
    return self.registry_items.where(:IsDeleted => false, :Purchased_ID => RegistryItem::ORDERED).count
  end

  def get_queue_for_payment(cart)
    items = RegistryItem.where("Registrant_ID = ? AND Purchased_ID != 3 AND Contributed > 0", self.id)
    sum = 0
    items.each do |item|
      if item.product.IsKind  # If it's a one of a kind item we can only apply credit toward that item'
        if cart.registry_items.index {|p| p.id == item.id } != nil
          sum += item.Contributed.to_f
        end
      else
        sum += item.Contributed.to_f
      end
    end

    sum += self.Cash.to_f
  end

  def get_list_products_for_withdrawals
    items = RegistryItem.joins(:product).where(:registry_items => {:Registrant_ID => self.id, :IsDeleted => false, :Purchased_ID.not_eq => RegistryItem::ORDERED, :Contributed.gt => 0},
            :products => {:IsKind => false}).order(:Contributed.desc).readonly(false)
  end

  def self.search(r, page, per_page, current_user_id = nil)

    r = r.split(' ')

    for i in 0..r.length - 1
      r[i] = '%' + r[i].to_s + '%'
    end

    if r.length == 1
      r << r[0]
      return Registrant.not_invited.active.where("FirstName LIKE ? OR LastName LIKE ? OR FirstNameCoCreated LIKE ? OR LastNameCoCreated LIKE ?", r[0], r[1], r[0], r[1]).paginate(:page => page, :per_page => per_page)
    else
      return Registrant.not_invited.active.where("FirstName LIKE ? OR LastName LIKE ? OR LastName LIKE ? OR FirstName LIKE ? OR FirstNameCoCreated LIKE ? OR LastNameCoCreated LIKE ? OR LastNameCoCreated LIKE ? OR FirstNameCoCreated LIKE ?",
                                                 r[0], r[1], r[0], r[1], r[0], r[1], r[0], r[1]).paginate(:page => page, :per_page => per_page)
    end
  end

  def self.count_all_give(r)
    r = r.split(' ')

    for i in 0..r.length - 1
      r[i] = '%' + r[i].to_s + '%'
    end

    if r.length == 1
      r << r[0]
      return Registrant.not_invited.active.where("FirstName LIKE ? OR LastName LIKE ? OR FirstNameCoCreated LIKE ? OR LastNameCoCreated LIKE ?", r[0], r[1], r[0], r[1]).count()
    else
      return Registrant.not_invited.active.where("FirstName LIKE ? OR LastName LIKE ? OR LastName LIKE ? OR FirstName LIKE ? OR FirstNameCoCreated LIKE ? OR LastNameCoCreated LIKE ? OR LastNameCoCreated LIKE ? OR FirstNameCoCreated LIKE ?",
                                                 r[0], r[1], r[0], r[1], r[0], r[1], r[0], r[1]).count()
    end
  end

  #######################################################
  # Get Recently Added Items
  #######################################################
  def get_recently_added(limit = 999999)
    self.registry_items.where(:IsDeleted => false, :Purchased_ID => RegistryItem::AVAILABLE).order(:created_at.desc).first(limit)
  end

	#-----------------------------------------------
	# Get Display Name
	#-----------------------------------------------
  def display_name
    if ((self.FirstName.length + self.LastName.length) > 14)
      if self.FirstName.length > 15
        self.FirstName[0..12] + '...'
      else
        self.FirstName
      end
    else
      self.FirstName + ' ' + self.LastName
    end
  end

  # Name Registry
  def name_registry
    "#{self.FirstName}#{self.FirstNameCoCreated.blank? ? "'s": " & #{self.FirstNameCoCreated}'s"} Registry"
  end

  # Name Couple
  def name_couple
    name = self.FirstName + " " + self.LastName
    name += " and " + (self.FirstNameCoCreated + " " + self.LastNameCoCreated) unless self.FirstNameCoCreated.blank? || self.LastNameCoCreated.blank?
    name
  end

  def follows?(registrant)
    self.follows.exists?(:followed_id => registrant.id)
  end

  def follow_fb_friends(new_friends)
    # Create new follows for friends that are not already being followed.
    new_friends.each do |fbuid|
      follow_reg = Registrant.find_by_fbuid(fbuid)
      unless follow_reg.blank? || self.follows?(follow_reg)
        self.followed_registrants << follow_reg
      end
    end
    self.save
  end

  protected

  def delete_space
    self.FirstName = self.FirstName ? self.FirstName.strip : nil
    self.LastName = self.LastName ? self.LastName.strip : nil
    self.Email = self.Email ? self.Email.strip : nil
    self.old_password = self.old_password ? self.old_password.strip : nil
    self.new_password = self.new_password ? self.new_password.strip : nil
  end

  def do_password_change
    if self.change_password == "1"
      if !self.fbuid.nil?
        errors.add(:new_password, "You can not change the password on a facebook user")
        return false
      elsif (!PasswordUtilities.check((old_password||""), self.Password))
        errors.add(:old_password, "Old password incorrect")
        return false
      else
        self.Password = PasswordUtilities.hash(self.new_password)
        self.change_password = nil
        self.old_password = nil
        self.new_password = nil
      end
    end
  end

  def do_password_set
    self.Password = PasswordUtilities.hash(self.new_password)
  end

  def set_default_section
    if self.sections.length == 0
      self.sections << Section.new(:order => 1)
    end
  end

  def set_defaults
    self.Description ||= "Welcome Guests, \n\nWe can't wait for the big day, and to see all the people we care about in one place to celebrate with us. Below is a list of some things we love that will help us start our new life together."
    self.ImageGUID ||= ImageUtilities.get_guid
    file = File.new("#{Rails.root}/public/images/defaultProfileImage.png")
    self.profile_image = file
    file.close
  end

  def reprocess_profile_pic
    self.profile_image.reprocess!
  end

end

