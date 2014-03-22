class Category < ActiveRecord::Base  
  has_many :products2categories, :foreign_key => 'Category_ID'
  has_many :products, :through => :products2categories

  has_many :stores, :foreign_key => 'Category_ID'

  acts_as_tree :foreign_key => 'parent_id', :order => "priority DESC"

  has_one :registry_item

  attr_accessor :parent_name

  validates :name,
                          :presence => true,
                          :length => {:minimum => 0, :maximum => 50}
  validates :per_shipment,
                          :presence => true,
                          :numericality  => {:message => "Not correct value",
                                             :greater_than_or_equal_to => 0,
                                             :less_than_or_equal_to => 100}
  validates :parent_id,
                          :presence => true,
                          :numericality  => {:message => "Not correct value", 
                                             :greater_than_or_equal_to => 0,
                                             :only_integer => true,
                                             :allow_nil => true
                                             }

  validates :priority,
                          :numericality  => {
                                             :greater_than_or_equal_to => 0,
                                             :less_than_or_equal_to => 50,
                                             :only_integer => true,
                                             :allow_nil => true
                                             }

  scope :visible, where(:visible => true)
  scope :with_stores, joins(:stores => :partner).where(:categories => {:visible => true}, :stores => {:IsDeleted => false, :visible => true}, :partners => {:IsDeleted => false}).group('categories.id')


  #-----------------------------------------------
  # Getting root category
  #-----------------------------------------------
  def self.root
    Category.find_by_is_root(true)
  end

  def self.hot
    @hot ||= Category.new(:id => -1, :name => "What's Hot", :parent => Category.root, :priority => 50)
  end
  #-----------------------------------------------
  # Getting the chain id parent categories
  #-----------------------------------------------

  def get_parent_ids
    ids = Array.new
    ids << self.id.to_i
    unless self.parent.nil? || self.parent.is_root
      ids << self.parent_id
      ids |= self.parent.get_parent_ids
    end
    ids
  end

  #-----------------------------------------------
  # Getting second level categories
  #-----------------------------------------------

  def self.get_second_level
    Category.where(:parent_id => Category.root.id)
  end

  #-----------------------------------------------
  # Getting category ids with children
  #----------------------------------------------
  def get_ids_with_children
    ids = Array.new
    ids << self.id
    children = self.children
    if children
      children.each do |c|
        ids |= c.get_ids_with_children
      end
    end
    ids
  end
    
  def self.get_csv
    categories = Category.all

    categories_csv = FasterCSV.generate do |csv|
      categories.each do |category|
        if category.parent == Category.root
          csv << [category.id, 0, category.name]
        elsif !category.root?
          csv << [category.id, category.parent_id, category.name]
        end
      end
    end
  end

  def catalog_menu()
    categories = Array.new
    categories << self
    categories += self.ancestors
    categories.reverse
  end

end
