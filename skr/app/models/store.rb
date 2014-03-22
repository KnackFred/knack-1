class Store < ActiveRecord::Base
  has_many :products2stores, :foreign_key => "Store_ID"
  has_many :products, :through => :products2stores

  belongs_to :category, :foreign_key => "Category_ID"

  belongs_to :partner, :foreign_key => "PartnerID"
  belongs_to :state, :foreign_key => "State_ID"

  attr_accessor :CategoryName

  validates :Name,
                          :presence => true,
                          :length => {:minimum => 0, :maximum => 50}

  validates :Street,
                          :presence => true,
                          :length => {:minimum => 0, :maximum => 50}

  validates :City,
                          :presence => true,
                          :length => {:minimum => 0, :maximum => 50}
  validates :Phone,
                          :length => {:minimum => 6, :maximum => 25}, 
                          :allow_blank => true
  validates :ZIP,
                          :presence => true,
                          :zip_format => {
                                    :message    => 'You must provide a valid ZIP',
                                    :allow_nil => :true}
  validates :Email,
                          :length => {:minimum => 0, :maximum => 50},
                          :email_format => {:allow_blank => true}
  validates :Description,
                          :length => {
                                    :minimum => 0,
                                    :maximum => 300,
                                    :if => Proc.new { |p| p.Description != '' && !p.Description.blank? }}
  validates :State_ID,
                        :presence => true,
                        :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :Category_ID,
                        :presence => true,
                        :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}

  scope :visible, joins(:partner).where({:stores => {:IsDeleted => false, :visible => true}, :partner => {:IsDeleted => false}})

  #-----------------------------------------------
  # Getting a count of the available products for the store in the catalog
  #-----------------------------------------------
  def count_products
    params = FindProductParams.new(1, 9999999, 's', self.id)
    Product.get_count_products('', params, nil, true)
  end

  #-----------------------------------------------
  # Getting orders for store
  #-----------------------------------------------
  def orders
    orders_array = Array.new
    self.products.each do |p|
      orders_array |= Order.joins(:products).where(:products => {:id => p.id})
      orders_array |= Order.joins(:registry_items).where(:registry_items => {:Product_ID => p.id})
    end
    orders_array
  end
  
  def self.get_csv(partner_id = nil)
    stores = Store
    stores = stores.where(:PartnerID => partner_id) unless partner_id.blank?
    stores_csv = FasterCSV.generate do |csv|
      stores.all.each do |store|
        csv << [store.id, 0, store.Name]
      end
    end
  end
end
